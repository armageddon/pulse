# Vector-space user matcher
# Treats entries in the user_place_activities table as 
# vectors in an n-dimensional space : one dimension per activity/place/place_activity
# You can easily get the dot product of two user's vectors like so:
#
#  v1.v2 =  v1x*v2x + v1y*v2y + v1z*v2z + ........
#          = SUM( v1n * v2n )   over all n
#
# That translates nicely to SQL & an INNER JOIN on 
#  user1 -> user1 activities -> user2 activites -> user2
#  Now, using the alternative way of calculating the dot product:
#
#  v1.v2 = |v1||v2|cos(theta)    where theta = angle between v1 and v2
# 
#  (so cos(theta) closer to 1 => smaller angle between vectors == closer match)
# 
# and the observation that as we're not considering DISlikes, so we'll
# never have a negative vector component, so cos(theta) will always be
# between 0 and 1, we can then use cos(theta) * 100 as a cheeky way of
# getting a percentage match
#
# Now for the bad news - 
# in this case, it's a little more complicated than the usual model, 
# because there's three entity types being matched
# So you *could* go the extra step and treat it as an n-dimensional reduction of 
# a 3n-dimensional space......
# OR you could keep it simple and have three different, independent types of match 
# I went for keeping it simple :)
module UserMatcher

  def self.matchesv1(user, page=0, per_page=8)
    if user.sex_preference!=nil && user.sex != nil && user.age_preference!=nil && user.sex != nil && user.age != nil
      @matches ||= User.paginate(:all, :conditions => [
          "sex = ? AND sex_preference = ? AND status = 1 AND age in (?) AND age_preference in (?) AND id != ?",
          user.sex_preference,
           user.sex,
          [ user.age_preference - 1,  user.age_preference,  user.age_preference + 1],
          [ user.age - 1,  user.age,  user.age + 1],
           user.id
        ], :include => [:places, :activities], :page => page, :per_page => per_page)
    else
      @matches = User.paginate(:all,:conditions=>"1 = 0",:limit => 0,:page=>1, :per_page=>1)
    end

  end

  def self.matchesv2(user, page=0, per_page=8)
 places     = user.places.find(:all, :include => [:categories])
    place_cats = places.map(&:categories).flatten.map(&:id).flatten
    place_cats = place_cats.select {|i| place_cats.select {|a| a == i}.length > 2 }

    activities = user.activities
    # activities = self.favorites.map(&:activity).map(&:id)

    if places.empty?
      users_by_place = []
    else
      users_by_place = User.find_by_sql("
        SELECT users.id as id, count(favorites.place_id) as place_count FROM users, favorites
        WHERE favorites.place_id in (#{places.map(&:id).join(',')})
        AND favorites.user_id = users.id
         AND status = 1
        GROUP BY users.id
        ")
    end

    if activities.empty?
      activity_users = []
    else
      activity_users = User.find(:all,
        :select  => "users.id, count(categories.id) as activity_count, sum(categories.weight) as all_points",
        :joins => :activities,
        :conditions => ['categories.id in (?)', activities.map(&:id)],
        :group => "users.id"
      )
    end

    if place_cats.empty?
      cat_users = []
    else
      cat_users = User.find_by_sql(%Q(
      SELECT users.id, categories.id AS category_id, count(categories.id), sum(categories.points) FROM "users"
        INNER JOIN "favorites" ON ("users"."id" = "favorites"."user_id")
        INNER JOIN "places" ON ("places"."id" = "favorites"."place_id")
        INNER JOIN "categorizations" ON ("places"."id" = "categorizations"."categorizable_id" AND "categorizations"."categorizable_type" = E'Place')
        INNER JOIN "categories" ON ("categories"."id" = "categorizations"."category_id")
        WHERE categories.id in (#{place_cats.join(',')})
        GROUP BY categories.id, users.id
      ))
  end

  matched_user_ids = users_by_place.select {|u| u.place_count.to_i >= 2 } |
  activity_users.select {|u| u.all_points.to_f >= 8.5 } |
  activity_users.select {|u| u.activity_count.to_i >= 2 } |
  cat_users.select {|u| u.count.to_i > 2 } |
  (users_by_place.select {|u| u.place_count.to_i >= 2 } & cat_users.select {|u| u.count.to_i >= 1 } ) |
  (activity_users.select {|u| u.activity_count.to_i >= 2 } & cat_users.select {|u| u.count.to_i >= 1 } ) |
  (activity_users.select {|u| u.activity_count.to_i >= 1 } & users_by_place.select {|u| u.place_count.to_i >= 1 })

  return [] if matched_user_ids.empty?

  User.find(:all, :conditions => ["sex = ? AND sex_preference = ? AND age = ? AND age_preference = ? AND id != ? AND id IN (?)",user.sex_preference,user.sex,user.age_preference, user.age,user.id,matched_user_ids.map(&:id)])


  end

  def self.matches_for( user, entity_type, limit )
    matches = User.find( :all,
      :select => 'users.*, 100.0 * (v1_dot_v2 / (user1_mod * user2_mod) ) AS pct_match',
      :conditions => ['T.user_id = ? AND (users.sex & ?) > 0 AND (users.sex_preference & ?) > 0', user.id, user.sex_preference, user.sex],
      :limit => limit,
      :order => 'pct_match DESC',
      :joins => "INNER JOIN (#{vector_space(entity_type)}) T ON T.user2_id = users.id"
    )
    matches.each{ |m| m.pct_match = m.pct_match.to_f }
    matches
  end
    
  def self.pct_match( user1_id, user2_id, entity_type )
    sql =<<-SQL
        SELECT
          user_id, user2_id, 
          100.0 * (v1_dot_v2 / (user1_mod * user2_mod) ) AS pct_match
        FROM
         (
          #{vector_space(entity_type)}
          ) T
          INNER JOIN users u1 ON u1.id = T.user_id
          INNER JOIN users u2 ON u2.id = T.user2_id
          
        WHERE user_id = #{user1_id} AND user2_id = #{user2_id}
          AND  (u1.sex & u2.sex_preference) > 0 AND (u1.sex_preference & u2.sex) > 0
    SQL
    r = ActiveRecord::Base.connection.execute sql
    r.all_hashes[0]['pct_match'].to_f rescue 0.0
  end
    
  protected

  # Returns SQL to derive a user vectors table
  # entity_type must be one of the literal strings -
  #   activity, place, or place_activity
  def self.user_vectors_old( entity_type, count_var_name = 'n' )
    "select user_id, #{entity_type}_id, count(*) AS #{count_var_name}
      from user_place_activities
      
      group by user_id, #{entity_type}_id"
  end
  #before delving into the maths, changed count(*) to 1 as it's only distinct matches we are concerned with
    def self.user_vectors( entity_type, count_var_name = 'n' )
    "select user_id, #{entity_type}_id, 1 AS #{count_var_name}
      from user_place_activities
where place_id <> 1
      group by user_id, #{entity_type}_id"
  end
  # returns SQL for calculating a users vector modulus from the vector space
  # entity_type must be one of the literal strings -
  #   activity, place, or place_activity
  def self.vector_mod_sql( entity_type, user_id_criteria )
    "SELECT SQRT(SUM(n*n)) AS vector_mod
      FROM ( #{user_vectors(entity_type)} ) T
      WHERE user_id = #{user_id_criteria}
      GROUP BY user_id
    "
  end
    
  def self.vector_space( entity_type )
    sql = <<-SQL
        SELECT
            upa1.user_id,
            SUM(n1*n2) AS v1_dot_v2,
            upa2.user_id AS user2_id,
             ( #{vector_mod_sql( entity_type, 'upa1.user_id' )} ) AS user1_mod,
             ( #{vector_mod_sql( entity_type, 'upa2.user_id' )} ) AS user2_mod
        FROM
          users
          INNER JOIN (#{user_vectors(entity_type, 'n1')}) upa1 
            ON upa1.user_id = users.id
          INNER JOIN (#{user_vectors(entity_type, 'n2')}) upa2 
            ON upa2.#{entity_type}_id = upa1.#{entity_type}_id

        WHERE upa1.user_id != upa2.user_id
        GROUP BY upa1.user_id, user2_id
    SQL
  end
end
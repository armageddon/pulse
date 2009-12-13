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
    
    def self.matches_for( user, entity_type, limit )
      User.find( :all,
        :select => 'users.*, 100.0 * (v1_dot_v2 / (user1_mod * user2_mod) ) AS pct_match',
        :conditions => ['T.user_id = ? AND (users.sex & ?) > 0 AND (users.sex_preference & ?) > 0', user.id, user.sex_preference, user.sex],
        :limit => limit,
        :order => 'pct_match DESC',
        :joins => "INNER JOIN (#{vector_space(entity_type)}) T ON T.user2_id = users.id"
          )
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
      r.all_hashes[0]['pct_match'].to_f rescue nil
    end
    
  protected

    # Returns SQL to derive a user vectors table 
    # entity_type must be one of the literal strings -
    #   activity, place, or place_activity
    def self.user_vectors( entity_type, count_var_name = 'n' )
      "select user_id, #{entity_type}_id, count(*) AS #{count_var_name}
      from user_place_activities
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
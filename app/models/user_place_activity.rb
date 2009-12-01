class UserPlaceActivity < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity
  belongs_to :place
  belongs_to :place_activity
  
    validates_presence_of     :place_activity_id

  
  #validates_uniqueness_of :user_id, :scope => [:place_id, :activity_id], :message => "You have already added this activity"
  fires :addeduserplaceactivity, :on => :create, :actor => :user, :subject => :self
  #todo - when does create fire - on new or on save?
  
  def self.search_user_place_activities(params, current_user)
      
      search_criteria = SearchCriteria.new(params, current_user).conditions
      logger.debug("conditions")
      logger.debug(search_criteria)

      results = {}
      use_age = search_criteria[0]
      use_gender = search_criteria[1]
      use_place_location = search_criteria[2]
      use_activity = search_criteria[3]
      conditions = search_criteria[4]
      if !use_activity && !use_place_location #just user (gender sex)
        logger.debug("people only")
        results = UserPlaceActivity.paginate(:select => "user_place_activities.place_activity_id,place_activities.activity_id,place_activities.place_id,user_place_activities.day_of_week, user_place_activities.time_of_day, count(user_id) as users_count", :order => "count(user_id) DESC", :joins => "inner join place_activities  on place_activities.id = user_place_activities.place_activity_id inner join users on users.id = user_place_activities.user_id",:group => 'user_place_activities.place_activity_id,place_activities.activity_id,place_activities.place_id,user_place_activities.day_of_week, user_place_activities.time_of_day', :conditions => conditions, :page => params[:page], :per_page => 10, :order => "count(user_id) DESC")
      end
      if !use_activity && use_place_location
        logger.debug("location")
        results = UserPlaceActivity.paginate(:select => "user_place_activities.place_activity_id,place_activities.activity_id,place_activities.place_id,user_place_activities.day_of_week, user_place_activities.time_of_day, count(user_id) as users_count", :order => "count(user_id) DESC", :joins => "inner join place_activities  on place_activities.id = user_place_activities.place_activity_id inner join users on users.id = user_place_activities.user_id inner join places on place_activities.place_id = places.id",:group => 'user_place_activities.place_activity_id,place_activities.activity_id,place_activities.place_id,user_place_activities.day_of_week, user_place_activities.time_of_day', :order => "count(user_id) DESC", :conditions => conditions, :page => params[:page], :per_page => 10)
      end
      if use_activity && !use_place_location
        logger.debug("activities")
        results = UserPlaceActivity.paginate(:select => "user_place_activities.place_activity_id,place_activities.activity_id,place_activities.place_id,user_place_activities.day_of_week, user_place_activities.time_of_day, count(user_id) as users_count", :order => "count(user_id) DESC", :joins => "inner join place_activities  on place_activities.id = user_place_activities.place_activity_id inner join users on users.id = user_place_activities.user_id inner join activities on place_activities.activity_id = activities.id",:group => 'user_place_activities.place_activity_id,user_place_activities.activity_id,user_place_activities.place_id,user_place_activities.day_of_week, user_place_activities.time_of_day', :order => "count(user_id) DESC", :conditions => conditions,:page => params[:page], :per_page => 10) 
      end
      if use_activity && use_place_location
        logger.debug("location and activities")
        results = UserPlaceActivity.paginate(:select => "user_place_activities.place_activity_id,place_activities.activity_id,place_activities.place_id,user_place_activities.day_of_week, user_place_activities.time_of_day, count(user_id) as users_count", :order => "count(user_id) DESC", :joins => "inner join place_activities  on place_activities.id = user_place_activities.place_activity_id inner join users on users.id = user_place_activities.user_id inner join places on place_activities.place_id = places.id inner join activities on place_activities.activity_id = activities.id", :order => "count(user_id) DESC",:group => 'user_place_activities.place_activity_id,user_place_activities.activity_id,user_place_activities.place_id,user_place_activities.day_of_week, user_place_activities.time_of_day', :conditions => conditions,:page => params[:page], :per_page => 10) 
      end
      logger.debug(results.length)
      return results
    #UserPlaceActivity.paginate(:conditions => conditions, :order => "count(user_id) DESC" ,:select => "user_place_activities.activity_id,user_place_activities.place_id, count(user_id) as users_count",:group => 'user_place_activities.activity_id,user_place_activities.place_id',:page => params[:page], :per_page => 12)  
    # :joins => "inner join places on user_place_activities.place_id = places.id", :conditions => ["latitude <= " +high_lat.to_s  + " and latitude >= " +low_lat.to_s  + " and longitude >= " +low_long.to_s  + " and longitude <= " +high_long.to_s
  end
  

end

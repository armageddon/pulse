class SearchController < ApplicationController
  before_filter :login_required
helper UsersHelper

  def index
    conditions = {}
    logger.debug(request.url)
    logger.debug(params[:t])
    case params[:t]
    when 'people' 
      conditions[:sex] = params[:s] if params[:s].present?
      conditions[:age] = params[:a] if params[:a].present?
      logger.debug('when people people')
      type = User
    when  'user' 
      logger.debug('when user people')
      type = User
    when  'users'
      logger.debug('when users people')
      type = User
    when 'activities'||'user_place_activities'
      
    else
      logger.debug('else def to places')
      type = Place
      params[:t] = 'places'
    end
    
    @distance = params[:distance]
    if params[:distance].to_s != "0" && params[:distance] != nil
      logger.info("in dist <> 0")
      @postcode = params[:postcode]
      geocoder = Graticule.service(:google).new "ABQIAAAAZ5MZiTXmjJJnKcZewvCy7RQvluhMgQuOKETgR22EPO6UaC2hYxT6h34IW54BZ084XTohEOIaUG0fog"
      logger.debug(params[:postcode])
      if   params[:postcode] != nil && params[:distance] != nil
        location = geocoder.locate('london ' + params[:postcode])
        latitude, longitude = location.coordinates
        if latitude != nil && longitude != nil
          lat_range = params[:distance].to_i / ((6076.00 / 5280.00) * 60.00)
          long_range = params[:distance].to_i / (((Math.cos(latitude * 3.141592653589 / 180.00) * 6076.00) / 5280.00) * 60.00)
          low_lat = latitude - lat_range
          high_lat = latitude + lat_range
          low_long = longitude - long_range
          high_long = longitude + long_range
          location_search = true;
        end
      end
    end
    
    if params[:t] == 'activities' ||  params[:t] == 'user_place_activities'  
      if location_search
        if params[:activity_id] == "0"
          logger.info("activity id = 0")
            @results = UserPlaceActivity.paginate(:select => "user_place_activities.activity_id, count(place_id) as place_count",:group => 'user_place_activities.place_id', :joins => "inner join places on user_place_activities.place_id = places.id", :conditions => ["latitude <= " +high_lat.to_s  + " and latitude >= " +low_lat.to_s  + " and longitude >= " +low_long.to_s  + " and longitude <= " +high_long.to_s],:page => params[:page], :per_page => 12)  
          else 
            @results = UserPlaceActivity.paginate(:select => "user_place_activities.activity_id, count(place_id) as place_count ",:group => 'user_place_activities.place_id', :joins => "inner join places on user_place_activities.place_id = places.id", :conditions => ["user_place_activities.activity_id = ? and latitude <= " +high_lat.to_s  + " and latitude >= " +low_lat.to_s  + " and longitude >= " +low_long.to_s  + " and longitude <= " +high_long.to_s,params[:activity_id]],:page => params[:page], :per_page => 12) 
          end
      else
        logger.info("No distance - selecting all user activities by activity id")
        if params[:activity_id] != "0"
          logger.info("activity id = 0")
          @results = UserActivity.paginate(:select => "activity_id, 0 as user_id",:group=>"activity_id",:conditions => ["user_activities.activity_id = ?",params[:activity_id]],:page => params[:page], :per_page => 12)
        else
          @results = UserActivity.paginate(:select => "activity_id, 0 as user_id",:group=>"activity_id",:page => params[:page], :per_page => 12)
        end
      end    
      if @results == nil || @results.length == 0 ||  @results[0].activity_id == nil
        @results = {}
        logger.info(@results.length)
      end
      
      
    elsif params[:t] == 'places' 
      if location_search
        if params[:q] != nil and params[:q] != ''
          @sphinx_places = type.search(params[:q],  :page => params[1], :per_page => 100)
          id_array = Array.new
          @sphinx_places.each do |s|
            id_array << s.id
          end
          id_array = id_array.inspect
          id_array["["] = "("
          id_array["]"] = ")"
          @results =Place.paginate( :conditions => ["latitude <= " +high_lat.to_s  + " and latitude >= " +low_lat.to_s  + " and longitude >= " +low_long.to_s  + " and longitude <= " +high_long.to_s + " and id in " + id_array],:page => params[:page], :per_page => 12 )
        else
          @results =Place.paginate( :conditions => ["latitude <= " +high_lat.to_s  + " and latitude >= " +low_lat.to_s  + " and longitude >= " +low_long.to_s  + " and longitude <= " +high_long.to_s],:page => params[:page], :per_page => 12 )
        end
      else
        @results =  type.search(params[:q], :page => params[:page], :per_page => 12)
      end
    else
      logger.info(params[:page])
      logger.info("search users")
      @results =  type.search(params[:q],
        :conditions => conditions,
        :page => params[:page], :per_page => 6)
    end
    
    
   logger.info(@params)
   logger.info("params: " +  params.to_s())
    
      respond_to do |format|
        format.html do
          logger.debug("html")
          render 
        end
          format.js do
            logger.info('results' + @results.to_s)
            if @results.length == 0
              render :text= > "<div id='results'>No results returned</div>"
            else
            render :partial => 'search_index', 
            #:locals => {
           #   :object => @results, :q => params[:q], :t => params[:t]
           # },
            :content_type => "text/html"
            end
          end

      end
  end

  def people
    respond_to do |format|
      format.js do
        @users = User.search_users(params)
        if @users == nil || @users.length == 0
          render :text=>"<div id='results'>No results returned</div>"
        else
          render :partial => 'shared/user_collection', :locals => { :collection => @users },  :content_type => "text/html"
        end
      end
    end
  end

  def place_activities
    respond_to do |format|
      format.js do
        @user_place_activities = UserPlaceActivity.search_user_place_activities(params)
        
        if  @user_place_activities == nil || @user_place_activities.length == 0
          render :text=>"<div id='activity_results'>No results returned</div>"
        else
          render :partial => 'shared/search_place_activity_collection', :locals => { :collection => @user_place_activities },  :content_type => "text/html"
        end
      end
    end
  end
  
  def events
     respond_to do |format|
        format.js do
          @user_place_activities = UserPlaceActivity.search_user_place_activities(params)
          if @user_place_activities.length == 0
            render :text=>"<div id='results'>No results returned</div>"
          else
            render :partial => 'shared/search_place_activity_collection', :locals => { :collection => @user_place_activities },  :content_type => "text/html"
          end
        end
      end
  end
  
  def activities
    respond_to do |format|
      format.js do
        render :partial => "activities"
      end
    end
  end
  
  def places
        logger.debug("places")
    respond_to do |format|
      format.js do
        render :partial => "places"
      end
    end
  end  
  
  def activity_list
    @category = params[:category]
    logger.debug(@category)
        logger.debug("activity_list")
        @activities = Activity.all(:conditions => {
          :category => params[:category]
          })
    respond_to do |format|
      format.js do
        render :json=> @activities.to_json
      end
    end
  end
  
end

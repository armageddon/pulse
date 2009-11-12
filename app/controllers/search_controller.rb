class SearchController < ApplicationController
  before_filter :login_required
helper UsersHelper

  def index
      
      @search_criteria = SearchCriteria.new(params, current_user)
      logger.debug("type%%%%%%%%%%%%%%%%%%%% " + @search_criteria.type.to_s)
      @users = User.search_users_advanced(params, current_user)
      @user_place_activities = UserPlaceActivity.search_user_place_activities(params, current_user)
      respond_to do |format|
        format.html do
          render 
        end
          format.js do
            logger.info('results' + @results.to_s)
            if @results == nil or @results.length == 0
              render :text=> "<div id='results'>No results returned</div>"
            else
              render :partial => 'search_index', :content_type => "text/html"
            end
          end

      end
  end

  def people_list
    @search_criteria = SearchCriteria.new(params, current_user)
    respond_to do |format|
      format.js do
        @users = User.search_users_advanced(params, current_user)
        if @users == nil || @users.length == 0
          render :text=>"<div style='width:500px' id='results'>No results returned</div>"
        else
          render :partial => 'shared/user_collection', :locals => { :collection => @users },  :content_type => "text/html"
        end
      end
    end
  end

  def people
    @search_criteria = SearchCriteria.new(params, current_user)
    respond_to do |format|
      format.js do
        @users = User.search_users_simple(params, current_user)
        if @users == nil || @users.length == 0
          render :text=>"<div style='width:500px' id='results'>No results returned</div>"
        else
          render :partial => 'shared/users_collection', :locals => { :collection => @users },  :content_type => "text/html"
        end
      end
    end
  end
  def place_activities
    @search_criteria = SearchCriteria.new(params, current_user)
    logger.debug("ages: ")
    logger.debug(@search_criteria.ages)
    respond_to do |format|
      format.js do
        @user_place_activities = UserPlaceActivity.search_user_place_activities(params, current_user)
        if  @user_place_activities == nil || @user_place_activities.length == 0
          render :text=>"<div style='width:500px' id='activity_results'>No results returned</div>"
        else
          render :partial => 'shared/search_place_activity_collection', :locals => { :collection => @user_place_activities },  :content_type => "text/html"
        end
      end
    end
  end
  
  def events
     respond_to do |format|
        format.js do
          @user_place_activities = UserPlaceActivity.search_user_place_activities(params, current_user)
          if @user_place_activities.length == 0
            render :text=>"<div style='width:500px' id='results'>No results returned</div>"
          else
            render :partial => 'shared/search_place_activity_collection', :locals => { :collection => @user_place_activities },  :content_type => "text/html"
          end
        end
      end
  end
  
  def activities
    @activities = Activity.search_activities(params, current_user)
    respond_to do |format|
      format.js do
        render :partial => "shared/activity_collection", :locals => {:collection => @activities}
      end
    end
  end
  
  def places
    logger.debug("places")
    @places = Place.search_places(params, current_user)
    respond_to do |format|
      format.js do
        render :partial => "shared/place_collection", :locals => {:collection => @places}
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
  
  def search_criteria
    logger.info("asasasas")
    logger.info("params: " +  params.to_s())
    @search_criteria = SearchCriteria.new(params, current_user)
    logger.info(@search_criteria.to_s)
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
end

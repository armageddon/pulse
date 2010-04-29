class SearchController < ApplicationController
  before_filter :login_required
  helper UsersHelper

  def index
    logger.debug(params)
    @places = current_user.suggested_places
    @matches = current_user.matches(params[:page], 8)
    @search_criteria = SearchCriteria.new(params, current_user)
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
          render :partial => 'shared_object_collections/horizontal_users_collection', :locals => { :collection => @users, :reqpath=>'/search/people_list' },  :content_type => "text/html"
        end
      end
    end
  end

  def map_places
    @places = Place.search_places_map(params, current_user)
    respond_to do |format|
      format.js do
        render :json => @places.to_json
      end
    end
  end
  
  def user_place_activities
    @search_criteria = SearchCriteria.new(params, current_user)
    logger.debug("ages: ")
    logger.debug(@search_criteria.ages)
    @user_place_activities = UserPlaceActivity.search_user_place_activities(params, current_user)
     logger.debug('DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD' )
    respond_to do |format|
      format.js do

        if  @user_place_activities == nil || @user_place_activities.length == 0
          render :text=>"<div style='width:500px' id='activity_results_div'>No results returned</div>"
        else
          logger.debug('DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD' + @user_place_activities.total_entries.to_s)
          render :partial => 'user_place_activity_collection', :locals => { :collection => @user_place_activities },  :content_type => "text/html"
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
          render :partial => 'shared_object_collections/search_place_activity_collection', :locals => { :collection => @user_place_activities },  :content_type => "text/html"
        end
      end
    end
  end

  def people
    logger.debug('PEOPLE')
    @search_criteria = SearchCriteria.new(params, current_user)
    respond_to do |format|
      format.js do
        @users = User.search_users_simple(params, current_user)
        if @users == nil || @users.length == 0
          render :text=>"<div style='width:500px' id='activity_results_div'>No results returned</div>"
        else
          render :partial => 'user_collection', :locals => { :collection => @users },  :content_type => "text/html"
        end
      end
    end
  end

  def activities
      logger.debug('ACTIVITIES SEARCH ' )
    @activities = Activity.search_activities(params, current_user)
    respond_to do |format|
      format.js do
         if @activities == nil || @activities.length == 0
           logger.debug('ACTIVITIES SEARCH - no results' )
              render :text=> "<div style='width:500px' id='activity_results_div'>No activities found</div>"
         else
            render :partial => "activity_collection", :locals => {:collection => @activities}
         end
      end
    end
  end
  
  def places
    logger.debug("places")
    @places = Place.search_places(params, current_user)
    respond_to do |format|
      format.js do
        render :partial => "place_collection", :locals => {:collection => @places}
      end
    end
  end  

  def simple
    @users = User.search_users_simple(params, current_user,5)
    @places = Place.search_places(params, current_user,5)
    @activities = Activity.search_activities(params, current_user,5)
    respond_to do |format|
      format.js do
        render :partial => "search/simple_search", :locals => {:collection => @places}
      end
    end

  end

  def activity_list
    @category = params[:activity_category_id]
    @activities = Activity.all(:conditions => {
        :activity_category_id => params[:activity_category_id]
      })
    respond_to do |format|
      format.js do
        render :json=> @activities.to_json
      end
    end
  end
  
  def search_criteria
    @places = current_user.suggested_places
    @matches = current_user.matches(params[:page], 8)
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

  def nav
    list = [Place.search_places(params, current_user),User.search_users_simple(params, current_user),Activity.search_activities(params, current_user)]
    list.sort_by {|a| a.total_entries}
    case list[0][0]
    when Place
      params[:search_criteria][:type] = "2"
    when Activity
      params[:search_criteria][:type] = "3"
    when User
      params[:search_criteria][:type] = "1"
    end
    @search_criteria = SearchCriteria.new(params, current_user)
    render :template=> "search/index"  
  end

end

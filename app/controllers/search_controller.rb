class SearchController < ApplicationController
  before_filter :login_required

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
    when 'activities'
      logger.debug('activities')
      type = Activity
    else
      logger.debug('else def to places')
      type = Place
      params[:t] = 'places'
    end
   logger.info(@params)
   logger.info("params: " +  params.to_s())
    @results =  type.search(params[:q],
      :conditions => conditions,
      :page => params[:page], :per_page => 12)
      respond_to do |format|
          format.js do
            if @results.length == 0
              render :text=>"<div id='results'>No results returned</div>"
            else
            render :partial => 'search_index', 
            #:locals => {
           #   :object => @results, :q => params[:q], :t => params[:t]
           # },
            :content_type => "text/html"
            end
          end
          format.html do

            render 
          end
      end
  end

  def people
    logger.debug("people")
    respond_to do |format|
      format.js do
        render :partial => "people"
      end
    end
  end

  def activities
        logger.debug("activities")
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

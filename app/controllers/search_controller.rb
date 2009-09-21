class SearchController < ApplicationController
  before_filter :login_required

  def index
    conditions = {}
    conditions[:sex] = params[:s] if params[:s].present?
    conditions[:age] = params[:a] if params[:a].present?
    logger.debug(request.url)
    logger.debug(params[:t])
    case params[:t]
    when 'people' 
      logger.debug('people')
      type = User
    when  'user' 
      logger.debug('people')
      type = User
    when  'users'
      logger.debug('people')
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
    @results = type.search(params[:q],
      :conditions => conditions,
      :page => params[:page], :per_page => 12)
      logger.info(@results)
      respond_to do |format|
          format.js do
            if @results.count == 0
              render :text=>"<div id='results'>No results returned</div>"
            else
            render :partial => 'search_index', :locals => {
              :object => @results, :q => params[:q], :t => params[:t]
            },
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
  
  
end

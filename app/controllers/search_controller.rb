class SearchController < ApplicationController
  before_filter :login_required

  def index

    conditions = {}
    conditions[:sex] = params[:s] if params[:s].present?
    conditions[:age] = params[:a] if params[:a].present?
    logger.debug(request.url)
    case params[:t]
    when 'users'
      type = User
    when 'activities'
      type = Activity
    else
      type = Place
    end

    @results = type.search(params[:q],
      :conditions => conditions,
      :page => params[:page], :per_page => 12)
      
      respond_to do |format|
          format.js do
            render :partial => 'search_index', :locals => {
              :object => @results
            },
            :content_type => "text/html"
          end
          format.html do
            render
          end

      end
      
      
  end

  def people
    render
  end
end

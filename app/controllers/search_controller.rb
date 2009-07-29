class SearchController < ApplicationController
  before_filter :login_required

  def index

    conditions = {}
    conditions[:sex] = params[:s] if params[:s].present?
    conditions[:age] = params[:a] if params[:a].present?

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
  end

  def people
    render
  end
end

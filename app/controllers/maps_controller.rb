class MapsController < ApplicationController
  
  def index
   @search_criteria = SearchCriteria.new(params, current_user)
  end
  
end
  
  
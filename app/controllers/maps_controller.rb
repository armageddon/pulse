class MapsController < ApplicationController
  
  def index
   @search_criteria = SearchCriteria.new(params, current_user)
  end
  
  
  def map
    respond_to do |format|
      format.html do
         render :partial => "maps/map"   
       end
      format.js do
          render :partial => "maps/map"
      end
     
    end
    
  end
end
  
  
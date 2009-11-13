class MapsController < ApplicationController
  
  def index
   @search_criteria = SearchCriteria.new(params, current_user)
  end
  
  
  def map
    respond_to do |format|
      format.html do
        logger.debug('do html !!!!!!!!!!!!!')
         render :partial => "maps/map" 
         
       end
      format.js do
        logger.debug('do js !!!!!!!!!!!!!')
          render :partial => "maps/map"
      end
     
    end
    
  end
end
  
  
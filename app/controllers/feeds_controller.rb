class FeedsController < ApplicationController
  
  
  def feed
    @timeline_events = TimelineEvent.all()
    respond_to do |format|
      format.html { render }
      format.js do
          render :partial => "shared/object_collection", :locals => { :collection => @timeline_events }
      end    
    end
  end
end

class FeedsController < ApplicationController
  
  
  def feed
    @timeline_events = TimelineEvent.paginate(:all, :order=> 'created_at DESC', :page=>1, :per_page=> 15)
    respond_to do |format|
      format.html { render }
      format.js do
          render :partial => "shared/object_collection", :locals => { :collection => @timeline_events }
      end    
    end
  end
end

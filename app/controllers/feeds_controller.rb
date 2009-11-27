class FeedsController < ApplicationController
  
  
  def feed
    
    @timeline_events = TimelineEvent.paginate(:all, :order=> 'created_at DESC', :page=>params[:page], :per_page=> 5)
    respond_to do |format|
      format.html { render }
      format.js do
          render :partial => "shared_object_collections/feed_collection", :locals => { :collection => @timeline_events }
      end    
    end
  end
end

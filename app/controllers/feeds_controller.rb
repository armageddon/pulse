class FeedsController < ApplicationController
  
  
  def feed
    
    @timeline_events = TimelineEvent.paginate(:all, :conditions=>"icon_file_name is not null and users.status=1",:joins=>"INNER JOIN users on users.id = timeline_events.actor_id",:order=> 'created_at DESC', :page=>params[:page], :per_page=> 5)
    respond_to do |format|
      format.html { render :partial => "shared_object_collections/feed_collection", :locals => { :collection => @timeline_events } }
      format.js do
          render :partial => "shared_object_collections/feed_collection", :locals => { :collection => @timeline_events }
      end    
    end
  end
end

class UserEventsController < ApplicationController
  before_filter :login_required

  def index
    @events = current_user.events
  end

  def new
    @place = Place.find(params[:place_id])
    @event = current_user.events.new
    @event.place = @place
    respond_to do |format|
      format.html { render }
      format.js { render :partial => 'new_event', :locals => { :event => @event }, :layout => false, :content_type => "text/html" }
    end
  end

  def create
    @event = current_user.events.build(params[:event])
    respond_to do |format|
      if @event.save
        format.html { redirect_to account_events_path }
        format.js { render :nothing => true }
      else
        format.html { render :action => :new }
        format.js { render :nothing => true, :status => 500 }
      end
    end
  end

end

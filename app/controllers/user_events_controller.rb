class UserEventsController < ApplicationController
  before_filter :login_required

  def index
    @events = current_user.events
  end

  def new
    logger.debug("in new")
    @favorites = User.paginate(:joins=>"inner join user_favorites on user_favorites.friend_id = users.id", :conditions => "user_favorites.user_id = " + current_user.id.to_s,:page=>params[:page],:per_page=>100)
    @place = Place.find(1)
    place_activity_id = params[:place_activity_id].present? ?  params[:place_activity_id] : PlaceActivity.find(:first).id
    @place_activity = PlaceActivity.find(place_activity_id) 
    @event = current_user.events.new
    @event.when_time = Time.now
    # @event.place = @place
    respond_to do |format|
      format.html { render }
      format.js { render :partial => 'new_event', :locals => { :event => @event }, :layout => false, :content_type => "text/html" }
    end
  end

  def create
    #@event = current_user.events.build(params[:event])
    @event = Event.new
    time = DateTime.new(2010,params[:month].to_i, params[:day].to_i, params[:hour].to_i,params[:min].to_i)
    @event.start = time
    @event.user_id = current_user.id
    @event.description = params[:user_description] if params[:user_description].present?
    pa_id = params[:place_activity_id].to_i
    @event.place_activity_id=pa_id
    if @event.save
      success = true
      at = Attendee.new
      #todo put this in initializer or build
      at.event_id = @event.id
      at.user_id=current_user.id
      at.attendee_type = 1
      at.attendee_response = 1
      at.save
      if  params[:attenddee_ids].present?
        attendees = params[:attenddee_ids].split(',')
        attendees.each do |a|
          at = Attendee.new
          at.event_id = @event.id
          at.user_id=a
          at.attendee_type = 2
          at.attendee_response = 0
          at.save
        end
      end

      logger.debug(attendees)
    end
    # end
    respond_to do |format|
      if success
        format.html { render :nothing => true  }
        format.js { render :nothing => true }
      else
        format.html { render :action => :new }
        format.js { render :nothing => true, :status => 500 }
      end
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def user_events
    #for populating calendar
    events = Event.find(:all)
    es=Array.new
    events.each do |e|
      es << {:url => '/user_events/'+ e.id.to_s,:title=>PlaceActivity.find(e.place_activity_id).activity.name + ' at ' +PlaceActivity.find(e.place_activity_id).place.name , :start=> e.start}
    end
    respond_to do |format|
      format.js { render :json => es}
    end
  end


  def add_attendee
    user_id = params[:user_id]
    event_id = params[:event_id]
  end

  def guests_to_invite
    type = params[:type]
    pa_id = params[:pa_id]
    case type
    when 'favs'
      users = User.paginate(:joins=>"inner join user_favorites on user_favorites.friend_id = users.id", :conditions => "user_favorites.user_id = " + current_user.id.to_s,:page=>params[:page],:per_page=>100)
    when 'mats'
      users = current_user.matches(1,100)
    when 'haps'
      users = PlaceActivity.find(pa_id).users
    else
      users = {}
      #create collection for json conversion
      
    end
    ret=Array.new
    users.each do |u|
      ret << {:name=>u.first_name, :icon=>u.icon.url(:thumb) , :id=>u.id}
    end

    respond_to do |format|
      format.js { render :json => ret}
    end
  end

  def respond
      event_id = params[:event_id].to_i if params[:event_id].present?
      response_id = params[:response_id].to_i if params[:response_id].present?
      attendee = Attendee.find_by_event_id_and_user_id(event_id, current_user.id)
      if(attendee!=nil)
        attendee.attendee_response=response_id
      else
         attendee = Attendee.new
          attendee.event_id = event_id
          attendee.user_id=current_user.id
          attendee.attendee_type = 2
          attendee.attendee_response = 0
      end
       attendee.save
       response_text = ''
       case response_id
    when 1
       response_text = 'ATTENDING'
     when 2
     response_text   = 'MAYBE ATTENDING'
    when 3
       response_text = 'NOT ATTENDING'
    end
    render :text => response_text
    
  end
  
  def attendees
    type = params[:type]
    event_id = params[:event_id]
    case type
    when "1"
      users = User.paginate(:joins=>"inner join attendees on attendees.user_id = users.id", :conditions => "attendees.event_id = " +event_id + " and attendees.attendee_response =" + type, :page=>1,:per_page=>100)
    when "2"
       users = User.paginate(:joins=>"inner join attendees on attendees.user_id = users.id", :conditions => "attendees.event_id = " +event_id+ " and attendees.attendee_response =" + type,:page=>1,:per_page=>100)
    when "3"
       users = User.paginate(:joins=>"inner join attendees on attendees.user_id = users.id", :conditions => "attendees.event_id = " +event_id+ " and attendees.attendee_response =" + type,:page=>1,:per_page=>100)
    else
       users = User.paginate(:joins=>"inner join attendees on attendees.user_id = users.id", :conditions => "attendees.event_id = " +event_id+ " and attendees.attendee_response =" + type,:page=>1,:per_page=>100)
    end

     sql =<<-SQL
        select
        sum(case attendee_response when 0 then 1 else 0 end) as not_responded,
        sum(case attendee_response when 1 then 1 else 0 end) as attending,
        sum(case attendee_response when 2 then 1 else 0 end) as maybe,
        sum(case attendee_response when 3 then 1 else 0 end) as not_attending
        from attendees
        where event_id = #{event_id}
  SQL
     r = ActiveRecord::Base.connection.execute sql

     ret=Array.new
    r.all_hashes.each do |h|
       ret << {:not_responded=>h['not_responded'], :attending=> h['attending'] , :maybe=> h['maybe'] , :not_attending=> h['not_attending'] }
     end
    


   
    users.each do |u|
      ret << {:name=>u.first_name, :icon=>u.icon.url(:thumb) , :id=>u.id}
    end

    respond_to do |format|
      format.js { render :json => ret}
    end

  end
end


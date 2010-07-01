class UserMessagesController < ApplicationController

  # This controller is a bit weird. Since there aren't
  # individual message views, #show is really an index
  # view of all messages scoped to a specific user
  # while #index is all for other users. There isn't
  # a #create.
  
  # A better way of thinking about this is as a conversation
  # that is always happening, and just being updated.

  before_filter :login_required
  before_filter :set_other_user,  :only => [:show, :update]

  def admin
    if current_user.admin
      render :template => "user_messages/admin", :layout => false
    else
      render :text => 'you are not authorised'
    end
  end

  def index
    @places = current_user.suggested_places
    @matches = current_user.matches(params[:page], 8)
    @messages = current_user.messages.find(:all,:order=>'created_at desc')
    current_user.read_all_messages!
  end

  def show
    @places = current_user.suggested_places
    @matches = current_user.matches(params[:page], 8)
    @message  = current_user.sent_messages.build
    @messages = Message.between(current_user.id, @other_user.id)
  end

  def update
    logger.debug("Message update")
    if params[:reply].present?
      case params[:reply]
      when 'yes'
        @body = YES_MAIL
      when 'maybe'
        @body = MAYBE_MAIL
      when 'no'
        @body=NO_MAIL
      end
      @message = current_user.sent_messages.build(:recipient_id => @other_user.id, :body => @body)
    else
      @message = current_user.sent_messages.build(params[:message].merge(:recipient_id => @other_user.id))
    end
    
    respond_to do |format|
      if @message.save
        format.html do
          flash[:notice] = "Your message has been sent."
          redirect_to account_message_path(@other_user)
        end
        format.js { render :partial => "message", :locals => {:message => @message }}
      else
        format.html { render :action => 'show' }
        format.js { render :nothing => true, :status => 500 }
      end
    end
  end

  def meet
    logger.debug('meet')
    respond_to do |format|
      format.js { render :partial => 'meet', :locals=>{:recipient_id => params[:recipient_id]}}
      format.html { render :partial => 'meet', :locals=>{:recipient_id => params[:recipient_id]}}
    end
  end

  def create_meet
    @body = 'Hi ' + User.find(params[:recipient_id]).first_name + '. We hang out at the same places and I think we have a lot in common.  Would you like to meet?'
    @message = current_user.sent_messages.build(:recipient_id => params[:recipient_id],:body=>@body, :message_type=>1)
    @message.save
    render :nothing => true
  end

 def mail_test

    @host =  "http://www.hellopulse.com"
    @user = current_user

    case params[:type]
    when 'activities'
      @meet_her_url = "http://aeser.co.uk/g/button-meet-her.jpg"
      @meet_him_url = "http://aeser.co.uk/g/button-meet-him.jpg"
      @host =  "http://www.hellopulse.com"
      @user = User.find(32)
      @subject = "What’s shaking on HelloPulse?"
      @gender = @user.sex_preference == 1 ? 'men' : 'women'
      @crm_activitites = CrmData.crm_activitites(current_user,3)
      @users = Array.new
      @happenings = Array.new
      @crm_activitites.each do |u|
        @users << u
        @happenings << u.user_place_activities.find(:last,:conditions=>"description is not null and description <> ''")
      end


      render :template => 'user_mailer/activity_reminder' , :layout => false

    when 'happenings'
      @subject = "Here are the singles pulsing in London"
      @user = current_user
      @heading = "Great to have you on board. Check out your weekly matches!"
      @meet_her_url = "http://aeser.co.uk/g/button-meet-her.jpg"
      @meet_him_url = "http://aeser.co.uk/g/button-meet-him.jpg"
      #todo: allow for men and women here#
      #todo: ensure happening is the latest one
      @gender = @user.sex_preference == 1 ? 'men' : 'women'
      @users = Array.new
      @happenings = Array.new
      CrmData.crm_matches(current_user,5).each do |u|
        @users << u
        @happenings << u.user_place_activities.find(:last,:conditions=>"description is not null and description <> ''")
      end
      render :template => 'user_mailer/daily_matches' , :layout => false

    when 'welcome'
      render :template => 'user_mailer/signup_notification' , :layout => false

    when 'notifications'
      @users = Array.new
      @happenings = Array.new
      @user = current_user
      @crm_activitites = CrmData.crm_activitites(@user,3)
      @meet_her_url = "http://aeser.co.uk/g/button-meet-her.jpg"
      @meet_him_url = "http://aeser.co.uk/g/button-meet-him.jpg"
      @friend=User.find(32)
      @crm_activitites.each do |u|
        @users << u
        @happenings << u.user_place_activities.find(:last,:conditions=>"description is not null and description <> ''")
      end

      @subject = "What’s shaking on HelloPulse?"
      @content_type =  "text/html"
      render :template => 'user_mailer/notification' , :layout => false

    when 'photos'
      @subject = "No photo, No action"
      @user = current_user
      #todo: allow for men and women here
      @gender = @user.sex_preference == 1 ? 'men' : 'women'
      @crm_photos = CrmData.crm_photos(current_user,4)
      @user1 = @crm_photos[0]
      @user2  =  @crm_photos[1]
      @user3 = @crm_photos[2]
      @user4 = @crm_photos[3]
      render :template => 'user_mailer/photo_reminder' , :layout => false
    else

    end

  end

  private
  
  def set_other_user
    # TODO: check matching
    @other_user = User.find_by_username(params[:id])
  end
  
end

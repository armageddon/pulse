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
  private
  
  def set_other_user
    # TODO: check matching
    @other_user = User.find_by_username(params[:id])
  end
  
end

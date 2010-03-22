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
    @message = current_user.sent_messages.build(params[:message].merge(:recipient_id => @other_user.id))
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
  
  private
  
  def set_other_user
    # TODO: check matching
    @other_user = User.find_by_username(params[:id])
  end
  
end

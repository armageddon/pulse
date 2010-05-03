class UserInvitationsController < ApplicationController
  before_filter :login_required

 skip_before_filter :verify_authenticity_token, :only => [:invite]

  def import
    render :template => '/user_invitations/import.html', :layout => false
  end

  def invite
    render :template => '/user_invitations/invite.html'
  end

  def sender
      recips = params[:q]
      logger.debug(recips)
      recip_list = recips.split(',')
      logger.debug(recip_list.length)
      UserMailer.deliver_invitations(current_user,recip_list)
      render :nothing => true 
     #@invitation = current_user.invitations.build()
     #  @invitation =.

    #   if @invitation.save
     #   format.html { redirect_to new_account_invitation_path }
    #    format.js { render :nothing => true }

     # else
    #    format.html { render :action => :news }
    #    format.js { render :nothing => true, :status => 500 }

    #  end
  end

  def new
    @invitation = Invitation.new
    render :layout => false
  end

  def create
    @invitation = current_user.invitations.build(params[:invitation])
    respond_to do |format|
      if @invitation.save
        format.html { redirect_to new_account_invitation_path }
        format.js { render :nothing => true }
        
      else
        format.html { render :action => :news }
        format.js { render :nothing => true, :status => 500 }
        
      end
    end
  end

end

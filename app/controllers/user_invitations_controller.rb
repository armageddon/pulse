class UserInvitationsController < ApplicationController
  before_filter :login_required

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

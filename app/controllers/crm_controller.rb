class CrmController < ApplicationController

  def index
    #note+messages
    @users = User.find(:all)
    @usersmatches_note_matches = User.find(:all, :conditions=> 'note_matches = 1')
    @usersmatches = User.find(:all,:conditions=>"(mail_matches  < DATE_SUB(CURRENT_DATE(), INTERVAL '7' DAY) or mail_matches is null ) and note_matches = 1")
    @user_match_ids = Array.new
    @usersmatches.each do |u|
      @user_match_ids << u.id
    end
    # @nophoto_users = Users.find(:all, :conditions=>'')
    #@nophoto_note_users = Users.find(:all, :conditions=>'')
    #@noactivity_users = Users.find(:all, :conditions=>'')
    #@noactivity_note_users = Users.find(:all, :conditions=>'')

    render :template => 'crm/admin', :layout=>false
  end

  def match
    u = User.find(params[:id])
    u.mail_matches = Time.now
    u.save
   logger.debug(params[:id])
      UserMailer.deliver_daily_matches(u)
      m = MailerMessage.new
      m.user_id = u.id
      m.type = 2
      m.mail_text = 'txt'
      m.save

     render :text => 's'
  end
 
end
class ActivitiesController < ApplicationController
  include CrmData
  skip_before_filter :verify_authenticity_token, :only => [:post_activity_to_facebook]

  def post_activity_to_facebook
    user = User.find(params[:user_id])
    activity = Activity.find(:first,:conditions=>{:admin_user_id => user.id })
    facebook_act_session = Facebooker::Session.create
    facebook_act_session.secure_with!(user.fb_session_key)
    facebook_act_session.post("facebook.stream.publish", :action_links=> '[{ "text": "Check out HelloPulse!", "href": "http://www.hellopulse.com"}]', :message => 'Some singles added ' + activity.name + ' to their HelloPulse page. ', :uid=>activity.fb_page_id)
    render :text=>'post to facebook'
  end

  def partner
    #@activity = Activity.find(:first,:conditions=>{:auth_code => params[:code], :admin_user_id => nil }) if params[:code] != nil
    #   if @activity == nil && current_user!= false &&current_user.status==3
    #       @activity = Activity.find(:first,:conditions=>{ :admin_user_id => current_user.id })
    #   end
    # if @activity == nil
    # render :text => 'The login code you provided does not match one in our system. Please try again'
    #  logger.debug('no such')
    #  redirect_to  :controller=>'sessions' , :action=>'partner'
    #else
    params[:id].present? ? @activity =  Activity.find(params[:id]) : @activity =  Activity.find_by_admin_user_id(current_user.id)
    render :text => 'Dear partner. An error has occured . please contact HelloPulse admin' and return if @activity == nil
    @users = @activity.users.paginate(:all,:group => :user_id, :page => params[:page], :per_page => 6)
    @user_place_activities = @activity.user_place_activities.paginate(:order=>'created_at DESC',:page=>1,:per_page=>10)
    render :template => 'activities/show', :locals => {:activity => @activity, :auth_code =>params[:code] }
    # end
  end

  def admin
    if current_user.admin
      render :template => "activities/admin", :layout => false
    else
      render :text => 'you are not authorised'
    end
  end

  def update
    activity = Activity.find(params[:activity_id])
    activity.auth_code = params[:auth_code]
    activity.fb_page_id = params[:page_id]
    activity.update_attributes(params[:activity])
    redirect_to '/activities/admin'
  end

  def show
    # login_from_fb
    @activity =Activity.find(params[:id])
    @user_place_activities = @activity.user_place_activities.paginate(:order=>'created_at DESC',:page=>1,:per_page=>10)
    @users = @activity.users.paginate(:all,:group => :user_id, :page => params[:page], :per_page => 6)
  end

  def mail_test
 
    @host =  "http://www.hellopulse.com"
    @user = current_user
    
    case params[:type]
    when 'activities'
      @host =  "http://www.hellopulse.com"
      @user = User.find(32)
      @subject = "What’s shaking on HelloPulse?"
      @gender = @user.sex_preference == 1 ? 'men' : 'women'
      @crm_activitites = CrmData.crm_activitites(current_user,3)
      @user1 = @crm_activitites[0]
      @user2  =  @crm_activitites[1]
      @user3 = @crm_activitites[2]
      @upa1 = @user1.user_place_activities.find(:last,:conditions=>"description is not null and description <> ''")
      @upa2 = @user2.user_place_activities.find(:last,:conditions=>"description is not null and description <> ''")
      @upa3 = @user3.user_place_activities.find(:last,:conditions=>"description is not null and description <> ''")
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
  
  
  def new_test
   
    respond_to do |format|

      format.html {render :template => '/activities/new_test.html' }
    end
  end
  
  def create
    @activity = Activity.new
    @activity.name =params[:activity_name]
    if @activity.save
      respond_to do |format|
        format.html do
          flash[:notice] = "You have added an place activity, user activity and user place"
          redirect_to account_places_path
        end
        format.js {render :text => 'added activity'  }
      end
    else
      respond_to do |format|
        format.html { render :action => :new}
        format.js { render :text => 'You have already added this activity', :status=>500 }
      end
    end
  end

  def users
    @activity=Activity.find(params[:id])
    @users = @activity.users.paginate(:all,:group => :user_id,:page=>params[:page], :per_page=>6)
    respond_to do |format|
      format.html { render }
      format.js { render :partial => "shared_object_collections/horizontal_users_collection", :locals => { :collection => @users, :reqpath=>'/activities/users' } }
    end
  end

  def user_place_activities
    @activity=Activity.find(params[:id])
    @user_place_activities = @activity.user_place_activities.paginate(:all, :order=>'created_at DESC',:page=>params[:page], :per_page=>10)
    respond_to do |format|
      format.html { render }
      format.js { render :partial => "user_place_activity_collection", :locals => { :collection => @user_place_activities } }
    end
  end

  def autocomplete
    s = params[:q]
    @activities = Activity.find(:all,:select=>"activities.id, activities.name, activities.activity_category_id, count(activities.id) as UPA" ,:group=>"activities.id, activities.name, activities.activity_category_id",:joins => "left join user_place_activities UPA on UPA.activity_id = activities.id", :order => "name", :conditions => ["name like ? ", "%#{params[:q]}%"])
    activity = Activity.find(:all,:select=>"activities.id, activities.name, activities.activity_category_id, 0 as UPA",:conditions=>["name = ?","#{s}"])
    res = Array.new
    if activity.length==0
      res << {:id=>0,:name=>s,:count=>'add this'}
    end
    @activities.each do |a|
      res << {:id=>a.id, :name=>a.name, :count=>a.UPA}
    end
    respond_to do |format|
      format.js { render :json => res}  #al - add json type as parameter here.
    end 
  end

  def activity_places
    activity_id = params[:activity_id]
    @places = Place.find(:all,:select=>"places.id, places.name, places.neighborhood, count(UPA.id) as UPA", :group=>"places.id, places.name,places.neighborhood",:joins=>"inner join user_place_activities UPA on UPA.place_id = places.id",:conditions=>"UPA.activity_id = " + activity_id.to_s)
    res = Array.new
    res <<  {:id=>0, :name=>'Search Places >>', :neighborhood=>'', :count=>''}
    @places.each do |p|
      res << {:id=>p.id, :name=>p.name, :count=>p.UPA, :neighborhood=>p.neighborhood}
    end
   
    respond_to do |format|
      format.js { render :json => res}  #al - add json type as parameter here.
    end
  end

end
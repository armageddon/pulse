class PlacesController < ApplicationController
  #before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => [:post_activity_to_facebook]

  def post_activity_to_facebook
    user = User.find(params[:user_id])
    place = Place.find(:first,:conditions=>{:admin_user_id => user.id })
    facebook_act_session = Facebooker::Session.create
    facebook_act_session.secure_with!(user.fb_session_key)
    facebook_act_session.post("facebook.stream.publish", :action_links=> '[{ "text": "Check out HelloPulse!", "href": "http://www.hellopulse.com"}]', :message => 'Some singles added ' + place.name + ' to their HelloPulse page. ', :uid=>place.fb_page_id)
    render :text=>'post to facebook'
  end
  
  def index
    @places = Places.find(:all)
  end
  
  def show
    @place =Place.find(params[:id])
    @user_place_activities = @place.user_place_activities.paginate( :order=>'created_at DESC',:page=>1,:per_page=>10)
    @users = @place.users.paginate(:all,:group => :user_id, :page => params[:page], :per_page => 6)
  end

  def admin
    if current_user.admin
      render :template => "places/admin", :layout => false
    else
      render :text => 'you are not authorised'
    end
  end

  def partner
    params[:id].present? ? @place =  Place.find(params[:id]) : @place =  Place.find_by_admin_user_id(current_user.id)
    #todo: what to do if no place
    render :text => 'Dear partner. An error has occured . please contact HelloPulse admin' and return if @place == nil
    @users = @place.users.paginate(:all,:group => :user_id, :page => params[:page], :per_page => 6)
    @user_place_activities = @place.user_place_activities.paginate(:order=>'created_at DESC',:page=>1,:per_page=>10)
    render :template => 'places/show', :locals => {:activity => @place, :auth_code =>params[:code] }
  end

  def update
    place = Place.find(params[:place_id])
    place.auth_code = params[:auth_code]
    place.fb_page_id = params[:page_id]
    if params[:place].present?
      place.icon = params[:place][:icon] if  params[:place][:icon].present?
      place.update_attributes(params[:place])
    else
      place.save
    end
    redirect_to '/places/admin'
  end
  
  def users
    @place=Place.find(params[:id])
    @users = @place.users.paginate(:all,:group => :user_id,:page=>params[:page], :per_page=>6)
    respond_to do |format|
      format.html { render }
      format.js { render :partial => "shared_object_collections/horizontal_users_collection", :locals => { :collection => @users, :reqpath=>'/places/users' } }
    end
  end

  def user_place_activities
    @place=Place.find(params[:id])
    @user_place_activities = @place.user_place_activities.paginate(:all, :order=>'created_at DESC',:page=>params[:page], :per_page=>10)
    respond_to do |format|
      format.html { render }
      format.js { render :partial => "user_place_activity_collection", :locals => { :collection => @user_place_activities } }
    end
  end
  
  def autocomplete
    @places = Place.find(:all,:order => "name", :conditions => ["name like ? ", "#{params[:q]}%"])
    results = @places.map {|p| "#{p.name}"+" <span style='font-size:9px'>#{p.neighborhood}</span>|#{p.id}"}.join("\n")
    render :text => results
  end

  def autocomplete_new
    s = params[:q]
    @places = Place.find(:all,:order => "name", :limit=>"50",:conditions => ["name like ? ", "#{s}%"])
    place = Place.find(:all,:order => "name", :conditions => ["name = ? ", "#{s}"])
    res = Array.new
    if place.length==0
      res << {:id=>-1,:name=>s,:count=>'add this place', :neighborhood=>''}
    end
    
    @places.each do |p|
      res << {:id=>p.id, :name=>p.name, :count=>0, :neighborhood=>p.neighborhood}
    end
    respond_to do |format|
      format.js { render :json => res}
    end
  end

  def info_window
    begin
    logger.debug('PLACEID ' + params[:id].to_s )
    place = Place.find(params[:id].to_i)
    pics = '<div>'
    i = 0
    place.users.paginate(:all,:group => :user_id,:page=>params[:page], :per_page=>8).each do |u|
      logger.debug(pics)
      pics += "<div style='float:left;margin-right:2px'><a href='/profiles/"+u.username+"'><img width='25px' height='25px' src='" + u.icon.url(:thumb) + "' alt='7_thumb'/></a></div>" if u.icon.url(:thumb)  != nil
    end
    pics += "<div class='clear'></div>"
    pics += "</div>"
    s = ''
    s += '<div style="float:left">'
    s += '<img width="30px" height="30px" src="'+place.icon.url(:thumb)+'" alt="7_thumb"/>'
    s += '</div>'
    s += '<div style="float:left">'
    s += '<a style="padding-left:10px" href="/places/'+place.id.to_s+'">'+place.name+'</a>'
    s += '<div class="clear"></div>'
    s += '<span style="font-size:9px;padding-left:10px">'+ place.address + ' ' + place.neighborhood + '</span>'
    s += '</div>'
    s += '<div class="clear"></div>'
    s += '<div style="float:left">'
    if place.user_place_activities.length > 1
      s += place.user_place_activities.length.to_s+ ' things happening here'
    else
      s += '1 thing happening here'
    end
    s += '</div>'
    s += '<div class="clear"></div>'
    s += pics
    render :text => s and return
    rescue
      render :text => '?' and return
    end

  end

end
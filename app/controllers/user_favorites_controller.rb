class UserFavoritesController < ApplicationController
  before_filter :login_required
  
  def index
    @favorites = User.paginate(:joins=>"inner join user_favorites on user_favorites.friend_id = users.id", :conditions => "user_favorites.user_id = " + current_user.id.to_s,:page=>1,:per_page=>6)
    logger.debug('FAVORITES: ' + @favorites.length.to_s)
    @user_place_activities = UserPlaceActivity.paginate(:select => "user_place_activities.id,user_place_activities.place_activity_id,user_place_activities.day_of_week, user_place_activities.time_of_day", :order => "user_place_activities.created_at DESC", :joins => "inner join users on users.id = user_place_activities.user_id ", :conditions => 'user_id = ' + current_user.id.to_s, :page => params[:page], :per_page => 10)
    logger.debug('USERPLACEACTIVITIES: ' + @user_place_activities.length.to_s)
    @places = current_user.suggested_places
    @matches = current_user.matches(params[:page], 8)
    @view = "user_favorites"
    respond_to do |format|
      format.html { render }
      format.js do
      end
    end
  end

  def new
    @user_favorite = current_user.user_favorites.build(params[:friend_id])
    if @user_favorites.save
      respond_to do |format|
        format.html { render }
        format.js do
          render :text => "you added a friend"
        end
      end
    else
        render :text => "oops"
    end
  end

  def create
    logger.debug("in user favourites create")
    
    @favorite = current_user.user_favorites.build(:friend_id => params[:friend_id])
    respond_to do |format|
      if params[:friend_id] != current_user.id.to_s && @favorite.save
        format.html do
          flash[:notice] = "You have added #{@favorite.place.name}"
          render :text => "made user fav"
        end
        format.js do
          render :text => "made user fav"
        end
        
      else
         format.html { render :nothing => true, :status => 500 }
        format.js { render :nothing => true, :status => 500 }
       
      end
    end
  end

  def destroy
    logger.debug("in destroy")
    @favorite = current_user.user_favorites.all(:conditions => ["friend_id = ?",params[:friend_id]]);
    logger.debug(@favorite.id)
    @favorite[0].destroy
    respond_to do |format|
      format.js do
        render :nothing => true
      end
    end
  end

  def users

    @favorites = User.paginate(:joins=>"inner join user_favorites on user_favorites.friend_id = users.id", :conditions => "user_favorites.user_id = " + current_user.id.to_s,:page=>params[:page],:per_page=>6)
      logger.debug('FAVORITES: ' + @favorites.length.to_s)
    respond_to do |format|
      format.html { render }
      format.js { render :partial => "shared_object_collections/horizontal_users_collection", :locals => { :collection => @favorites , :reqpath=>'/favorites/users' } }
    end
  end

  def user_place_activities
    @user_place_activities = current_user.user_place_activities.paginate(:all, :order=>'created_at DESC',:page=>params[:page], :per_page=>10)
    respond_to do |format|
      format.html { render }
      format.js { render :partial => "user_place_activity_collection", :locals => { :collection => @user_place_activities } }
    end
  end
end

class UserFavoritesController < ApplicationController
  before_filter :login_required
  
  def index
    @favorites = User.paginate(:joins=>"inner join user_favorites on user_favorites.friend_id = users.id", :conditions => "user_favorites.user_id = " + current_user.id.to_s,:page=>1,:per_page=>6)
    logger.debug('FAVORITES: ' + @favorites.length.to_s)
    @user_place_activities = UserPlaceActivity.paginate(:select => "user_place_activities.place_activity_id,user_place_activities.day_of_week, user_place_activities.time_of_day, count(user_id) as users_count", :order => "count(user_id) DESC", :joins => "inner join users on users.id = user_place_activities.user_id ",:group => 'user_place_activities.place_activity_id,user_place_activities.day_of_week, user_place_activities.time_of_day', :conditions => 'user_id = ' + current_user.id.to_s, :page => params[:page], :per_page => 10, :order => "count(user_id) DESC")
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
      if @favorite.save
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

end

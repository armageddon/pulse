class UserFavoritesController < ApplicationController
  before_filter :login_required
  
  def index
    @favorites = []
    current_user.user_favorites.each do |uf|
      @favorites << User.find(uf.friend_id)
    end
    @user_activities = current_user.user_activities
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

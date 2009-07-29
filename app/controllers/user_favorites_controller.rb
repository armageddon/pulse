class UserFavoritesController < ApplicationController
  before_filter :login_required

  def new
    @favorite = Favorite.new
    if params[:place_id]
      @favorite.place = Place.find(params[:place_id])
    end

    respond_to do |format|
      format.js do
        render :partial => "new_place",
          :locals => { :favorite => @favorite },
          :layout => false
        end
      format.html { render }
    end
  end

  def create
    @favorite = current_user.favorites.build(params[:favorite])
    respond_to do |format|
      if @favorite.save
        format.js do
          render :partial => 'shared/object', :locals => {
            :object => @favorite.place
          },
          :content_type => "text/html"
        end
        format.html do
          flash[:notice] = "You have added #{@favorite.place.name}"
          redirect_to account_places_path
        end
      else
        format.js { render :nothing => true, :status => 500 }
        format.html { render :action => :new }
      end
    end
  end

  def destroy
    @favorite = current_user.favorites.find_by_place_id(params[:id])
    @favorite.destroy
    respond_to do |format|
      format.js do
        render :nothing => true
      end
    end
  end

end

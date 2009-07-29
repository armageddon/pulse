class PlacePicturesController < ApplicationController
  before_filter :login_required, :find_place
  
  def index
    @pictures = @place.pictures
  end

  def show
    @picture = @place.pictures.find(params[:id])
  end

  def new
    @picture = @place.pictures.new
  end

  def update
    @picture = @place.pictures.find(params[:id])

    if @picture.update_attributes(params[:place_picture])
      redirect_to place_pictures_path(@place)
    else
      render :nothing => true, :status => 500
    end
  end

  def create
    @picture = @place.pictures.new(params[:place_picture])
    respond_to do |format|
      if @picture.save
        format.html { redirect_to place_pictures_path(@place) }
      else
        format.html { redirect_to place_pictures_path(@place) }
      end
    end
  end

  def destroy
    @picture = @place.pictures.find(params[:id])
    @picture.destroy
    flash[:notice] = "Picture deleted"
    redirect_to place_pictures_path(@place)
  end

  private

  def authorized?
    true
  end
  
  def find_place
    @place = Place.find(params[:place_id])
  end
end

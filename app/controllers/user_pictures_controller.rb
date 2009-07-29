class UserPicturesController < ApplicationController
  before_filter :login_required

  def index
    @pictures = current_user.pictures
  end

  def show
    @picture = current_user.pictures.find(params[:id])
  end

  def new
    @picture = current_user.pictures.new
  end

  def update
    @picture = current_user.pictures.find(params[:id])

    if @picture.update_attributes(params[:picture])
      redirect_to account_pictures_path
    else
      render :nothing => true, :status => 500
    end
  end

  def create
    @picture = current_user.pictures.new(params[:user_picture])
    if @picture.save
      if params[:iframe]
        render :text => current_user.icon.url(:profile)
      else
        redirect_to account_pictures_path
      end
    else
      if params[:iframe]
        render :nothing => true, :status => 500
      else
        redirect_to account_pictures_path
      end
    end
  end

  def destroy
    @picture = current_user.pictures.find(params[:id])
    @picture.destroy
    flash[:notice] = "Picture deleted"
    redirect_to account_pictures_path
  end

  private

  def authorized?
    true
  end
end

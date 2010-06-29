class UserConnectionsController < ApplicationController
  before_filter :login_required
#TODO: This is not in use - drop file
  def index
    @accepted_connections = current_user.connections.accepted
    @requested_connections = current_user.requested_connections.requested
  end

  def show
    @connection = current_user.connections.find_by_username(params[:id])
  end

  def new
    @connection = current_user.connections.new
    @connection.contact = User.find_by_username(params[:id])
  end

  def create
    #TODO: if @connection = Connection.request(current_user, params[:id])
    @connection = current_user.connections.build
    @connection.contact = User.find_by_username(params[:id])
    if @connection.save
      flash[:notice] = "A request has been sent to #{@connection.contact.username}"
      redirect_to profile_path(@connection.contact)
    else
      render :action => :new
    end
  end

  def update
    target_user = User.find_by_username(params[:id])
    @connection = current_user.connections.find_by_contact_id(target_user.id)
    if @connection.update_attributes(params[:connection])
      flash[:notice] = "ok, done"
      redirect_to profile_path(@connection.contact)
    else
      render :action => :new
    end
  end

  def approve
    target_user = User.find_by_username(params[:id])
    @connection = current_user.requested_connections.find_by_user_id(target_user.id)
    @connection.accept!
    redirect_to account_connections_path
  end

  def destroy
    target_user = User.find_by_username(params[:id])
    @connection = current_user.connections.find_by_contact_id(target_user.id)
    if @connection && @connection.destroy
      flash[:notice] = "ok, done"
      redirect_to account_connections_path
    else
      redirect_to account_connections_path
    end
  end

end

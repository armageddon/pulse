module AuthenticatedTestHelper
  # Sets the current user in the session from the user fixtures.
  def login_as(user)
    @request.session[:user_id] = user ? (user.is_a?(User) ? user.id : User.find_by_username(user.to_s).id) : nil
  end

  def authorize_as(user)
    @request.env["HTTP_AUTHORIZATION"] = user ? ActionController::HttpAuthentication::Basic.encode_credentials(users(user).login, 'monkey') : nil
  end
  
  def make_user(username = "quentin")
    Sham.reset
    user = User.make(:username => username.to_s)
    user.register!
    user.activate!
    user
  end
end

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include SimpleCaptcha::ControllerHelpers 
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details


 # before_filter :set_facebook_session
 # helper_method :facebook_session
 include AuthenticatedSystem
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password




  def login_required
    authorized? || access_denied
  end
  
  before_filter :set_user_language
  
  private 
  def set_user_language
    I18n.locale = 'en-GB'
  end
end

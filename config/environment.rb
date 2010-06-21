# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '2.3.1' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  config.gem "chronic"
  config.gem 'rubyist-aasm', :lib => 'aasm', :source => 'http://gems.github.com'
  config.gem 'faker'
  config.gem "right_aws"
  config.gem "javan-whenever", :lib => false, :source => 'http://gems.github.com'
  # added by Al
  #config.gem "rmagick"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  config.active_record.observers = [:user_observer,:attendee_observer,  :invitation_observer, :place_activity_observer, :place_observer, :activity_observer, :user_place_activity_observer, :user_favorite_observer]

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end
#
if Rails.env == "production"
  # http://67.23.21.94/   
  if Rails.public_path.include? ".co.uk"
    GOOGLE_MAPS_API_KEY = 'ABQIAAAAxWNpxzcfyhn7zYII6ArMwBTuVtZQfMdAwq5mbuzuAdL882aPpxTzrnL-bVk8wVuKyBuHCsbsgUxeJQ'
  elsif Rails.public_path.include? "174.143.128.98"
    GOOGLE_MAPS_API_KEY = 'ABQIAAAArdqGwpu3b8yNbPBH_W7VcxQMwoiYNRvMEoTjsAC5jD4uhD7CdhS80RwbHQzt5Fb-L64ks4UQJ7pY0A'
  else
    GOOGLE_MAPS_API_KEY = 'ABQIAAAArdqGwpu3b8yNbPBH_W7VcxRhKqGJz2XpjEX0yvpoqNJsCS6C3RQc357CAtK1DBmVMWVoj-V1g38HpQ'
  end
else
  GOOGLE_MAPS_API_KEY = 'ABQIAAAAZ5MZiTXmjJJnKcZewvCy7RQvluhMgQuOKETgR22EPO6UaC2hYxT6h34IW54BZ084XTohEOIaUG0fog'
end

if Rails.env == "production"
  HELLOPULSE_USER_ID = 209
  CALLBACK_URL = "http://hellopulse.com/fb_test"
  FB_APP_ID = 328522741457
  FB_SECRET_KEY = "0d0a2e7e1cd0bf9c9688e518f6aeb358"
else
  HELLOPULSE_USER_ID = 32
  CALLBACK_URL = "http://localhost:3000/fb_test"
  FB_APP_ID = 297512602099
  FB_SECRET_KEY = "a30c002eeb58d601fa6c3c84de076301"
  FB_APP_KEY = "6b47ec733b05df8cc3bcec60e2d5f7efgem"
end

ANYTHING_ACTIVITY_ID = 159;
ANYWHERE_PLACE_ID=1;
USER_PLACE_DESCRIPTION_TEXT = "tell us why you socialise here and whether it's good for meeting people"
BITLY_URL =  'http://bit.ly/atCD0U'

YES_MAIL="Great. Let's meet. Send me an message with some ideas!"
MAYBE_MAIL="Maybe…let’s get to know each other a bit first"
NO_MAIL="Thanks but I don't  think we're right for each other - it’s not you, it’s me (actually, it could be you)"

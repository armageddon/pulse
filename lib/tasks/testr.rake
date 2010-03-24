namespace :testr do
  task :fsttest => :environment do
    puts 'dssdsdsdsd'
    user = User.find_by_username('pierrearmageddon')
    UserMailer.deliver_signup_notification(user)
    RAILS_DEFAULT_LOGGER.info('in rake')
  end
end
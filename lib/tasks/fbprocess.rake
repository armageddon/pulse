namespace :fbprocess do

    task :pull => :environment do
    User.find(:all, :conditions=>'fb_pull = 0 and access_token is not null').each do |u|
      FbGrapher.pull(u.access_token)
    end
  end
end



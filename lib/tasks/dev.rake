namespace :staging do
  task :sync do
    puts "pulling most recent changes from github on myiagi"
    puts `ssh miyagi "cd /var/www/sites/pulse_staging/current; git pull"`
    puts `ssh miyagihands.com "touch /var/www/sites/pulse_staging/current/tmp/restart.txt"`
  end
end

task :testenv do
  RAILS_ENV="test"
end

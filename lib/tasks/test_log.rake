namespace :test_log do

    task :pull => :environment do
    Test.first()
    end
  end




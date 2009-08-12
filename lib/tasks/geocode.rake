namespace :geocode do
  task :places => :environment do
    STDOUT.sync = true
    Place.find_each(:conditions => ["(latitude is null or longitude is null) AND attempted_geocode is false"]) do |place|
      begin
        place.attempted_geocode = true
        place.geolocate
      rescue => e
        puts "#{place.id} #{e}"
      end
      place.save!

      puts place.id
      sleep 0.34
    end
  end
end
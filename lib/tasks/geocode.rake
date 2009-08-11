namespace :geocode do
  task :places => :environment do
    STDOUT.sync = true
    Place.find_each(:conditions => ["(latitude is null or longitude is null) AND attempted_geocode is false"]) do |place|
      begin
        place.attempted_geocode = true
        place.geolocate
      rescue => e
        puts "Error geocoding place #{place.id} #{place.name} -- #{e}"
      end
      place.save!
      if place.latitude.nil? || place.longitude.nil?
        puts "Failed to geocode #{place.id} #{place.name}"
      else
        print "."
      end
      sleep 0.34
    end
  end
end
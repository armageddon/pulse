namespace :geocode do
  task :places => :environment do
    STDOUT.sync = true
    Place.find_each(:conditions => ["latitude is null or longitude is null"]) do |place|
      begin
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
      sleep 0.33
    end
  end
end
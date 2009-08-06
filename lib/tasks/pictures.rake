namespace :pictures do
  task :upload_to_s3 => :environment do
    base_file_path = "/Users/coryforsyth/Desktop/images_part1/"
    
    Place.find_each(:conditions => {:uploaded_picture_to_s3 => false}) do |place|
      puts "#{place.id}"
      import_id = place.import_id
      filepath = base_file_path + import_id + ".jpg"
      if File.exist?(filepath)
        file = File.open(filepath)
        place.icon = file
        place.uploaded_picture_to_s3 = true
        place.save!
        file.close
      else
        place.icon = nil
        place.save!
        puts "No icon for place #{place.id} #{place.name}"
      end
    end
  end
end
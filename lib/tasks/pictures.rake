namespace :pictures do
  task :upload_to_s3 => :environment do
    STDOUT.sync = true
    
    class Net::HTTP
      alias_method :old_initialize, :initialize
      def initialize(*args)
        old_initialize(*args)
        @ssl_context = OpenSSL::SSL::SSLContext.new
        @ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
    end
    base_file_paths = ["/Users/cory/Desktop/images_part1/",
                       "/Users/cory/Desktop/images_part2/",
                       "/Users/cory/Desktop/images_part3/"]
    
    Place.find_each(:conditions => {:attempted_s3_upload => false}) do |place|
      place.attempted_s3_upload = true
      puts "#{place.id}"
      filepath = ""
      found_file = false
      base_file_paths.each do |base_file_path|
        filepath = base_file_path + place.import_id + ".jpg"
        if File.exist?(filepath)
          found_file = true
          break
        end
      end
      if found_file
        File.open(filepath) do |file|
          place.icon = file
          place.uploaded_picture_to_s3 = true
        end
      else
        place.uploaded_picture_to_s3 = false
        puts "No icon for place #{place.id} #{place.name}"
      end
      
      place.save!
    end
  end
end
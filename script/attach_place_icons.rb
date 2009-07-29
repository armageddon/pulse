require 'action_controller'
require 'action_controller/test_process.rb'

IMAGE_PATHS = [
  '/home/dusty/images_part1/',
  '/home/dusty/images_part2/',
  '/home/dusty/images_part3/'
]

ActiveRecord::Base.connection.select_rows("select id, import_id from places").each do |r|
  path = false
  IMAGE_PATHS.each do |p|
    wpath = p + r[1] + '.jpg'
    if File.exists? wpath
      path = wpath
      break
    else
      path = false
    end
  end
  
  if path
    begin
      p = Place.find(r[0])
      p.icon = ActionController::TestUploadedFile.new(path, 'image/jpeg')
      $stdout.write "Saving #{path} ... "
      $stdout.write p.save.to_s
      $stdout.write "\n"
    rescue Exception => e
      puts path
    end
    
  end
end

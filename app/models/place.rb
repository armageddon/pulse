class Place < ActiveRecord::Base

  define_index do
    indexes name
    indexes address
  end

  validates_presence_of :name

  has_attached_file :icon, 
    :styles => { :thumb => "75x75#", :profile => "160x160#" },
    :storage => :s3,
    :s3_credentials => File.join(Rails.root, "config", "amazon_s3.yml"),
    :path => "places/:id/:id_:style.:extension"
    # :path => ":rails_root/public/system/icons/places/:id/:id_:style.:extension"


  belongs_to :location
  has_many :favorites
  has_many :users, :through => :favorites
  has_and_belongs_to_many :categories
  has_many :events

  # before_create :geolocate

  def geolocate
    geocoder = Graticule.service(:yahoo).new "nkQVDsTV34FGqxIZ1GbIFRE5uat12NCKWXQxmy_MWgwSDGpB_vo0bHbEEf86ta54vbAktQw-"
    location = geocoder.locate address
    self.latitude = location.latitude
    self.longitude = location.longitude
  end

  def upcoming_events
    events.find(:all, :conditions => ['when_time >= ?', Time.now], :limit => 5)
  end

end

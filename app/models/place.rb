class Place < ActiveRecord::Base

  define_index do
    indexes name
    indexes address
  end

  validates_presence_of :name

  has_attached_file :icon, 
    :styles => { :thumb => "75x75#", :profile => "160x160#" },
    :storage => :s3,
    :s3_credentials => File.join(Rails.root, "config", "s3.yml"),
    :path => "places/:id/:id_:style.:extension"

  belongs_to :location
  has_many :favorites
  has_many :users, :through => :favorites
  has_and_belongs_to_many :categories
  has_many :events

  # before_create :geolocate

  def geolocate
    # geocoder = Graticule.service(:yahoo).new "nkQVDsTV34FGqxIZ1GbIFRE5uat12NCKWXQxmy_MWgwSDGpB_vo0bHbEEf86ta54vbAktQw-"
    geocoder = Graticule.service(:google).new "ABQIAAAAnfs7bKE82qgb3Zc2YyS-oBT2yXp_ZAY8_ufC3CFXhHIE1NvwkxSySz_REpPq-4WZA27OwgbtyR3VcA"
    location = geocoder.locate(address_for_geocoder)
    self.latitude = location.latitude
    self.longitude = location.longitude
  end
  
  def address_for_geocoder
    "#{address}, #{city}, #{zip}, UK"
  end

  def upcoming_events
    events.find(:all, :conditions => ['when_time >= ?', Time.now], :limit => 5)
  end

end

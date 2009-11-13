class Place < ActiveRecord::Base

  define_index do
    indexes :name
    indexes address
    has longitude
    has latitude
  end

  validates_presence_of :name

  has_attached_file :icon, 
    :styles => { :thumb => "75x75#", :profile => "160x160#" },
    :storage => :s3,
    :s3_credentials => File.join(Rails.root, "config", "s3.yml"),
    :path => "places/:id/:id_:style.:extension",
    :default_url => "/images/Question.png"

  belongs_to :location
  has_many :user_place_activities
  has_many :activities, :through => :user_place_activities
  has_many :user_places
  has_many :users, :through => :user_places
  
  has_many :events
  belongs_to :place_categories

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
  
  def self.search_places_map(params, current_user)
      search_criteria = SearchCriteria.new(params, current_user).conditions
      logger.debug("conditions")
      logger.debug(search_criteria)

      results = {}
      use_age = search_criteria[0]
      use_gender = search_criteria[1]
      use_place_location = search_criteria[2]
      use_activity = search_criteria[3]
      conditions = search_criteria[4]
       
       if !use_activity && !use_place_location #just user (gender sex)
         logger.debug("people only")
         results = Place.paginate(:select => "places.latitude, places.longitude, places.name, places.address, places.neighborhood, places.category, count(UPA.activity_id)", :order => "count(UPA.activity_id) DESC", :joins => "inner join user_place_activities UPA on UPA.place_id = places.id inner join users on users.id = UPA.user_id",:group => 'places.latitude, places.longitude, places.name, places.address, places.neighborhood, places.category', :conditions => conditions, :page => params[:page], :per_page => 100, :order => "count(UPA.activity_id) DESC")
       else
         results = Place.paginate(:select => "places.latitude, places.longitude, places.name, places.address, places.neighborhood, places.category,count(UPA.activity_id)", :order => "count(user_id) DESC", :joins => "inner join user_place_activities UPA on UPA.place_id = places.id inner join activities on activities.id = UPA.activity_id inner join users on users.id = UPA.user_id",:group => 'places.latitude, places.longitude, places.name, places.address, places.neighborhood, places.category', :order => "count(UPA.activity_id) DESC", :conditions => conditions, :page => params[:page], :per_page => 100)
       end
       logger.debug(results.length)
       return results
  end
  
  def self.search_places(params, current_user)
      #todo may need a switch here if we want to search places with joins to other tables
      #keep sphinx to one table searches for now
      search_criteria = SearchCriteria.new(params, current_user)
      search_criteria.conditions
      logger.debug(search_criteria.conditions)
      logger.debug(search_criteria.low_lat)
      logger.debug(search_criteria.high_lat)
      logger.debug(search_criteria.low_long)
      logger.debug(search_criteria.high_long)
      results = Place.search(params[:search_criteria][:keyword], :conditions => {:latitude => search_criteria.low_lat..search_criteria.high_lat, :longitude => search_criteria.low_long..search_criteria.high_long},  :page=>1, :per_page=>20)
      return results
    #UserPlaceActivity.paginate(:conditions => conditions, :order => "count(user_id) DESC" ,:select => "user_place_activities.activity_id,user_place_activities.place_id, count(user_id) as users_count",:group => 'user_place_activities.activity_id,user_place_activities.place_id',:page => params[:page], :per_page => 12)  
    # :joins => "inner join places on user_place_activities.place_id = places.id", :conditions => ["latitude <= " +high_lat.to_s  + " and latitude >= " +low_lat.to_s  + " and longitude >= " +low_long.to_s  + " and longitude <= " +high_long.to_s
  end

end

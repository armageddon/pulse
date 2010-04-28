class SearchCriteria 
  #al - method returns rails default logger.
  def logger
    RAILS_DEFAULT_LOGGER
  end
  
  attr_reader :keyword, :sex, :sex_preference,:sex_preferences 
  attr_reader :ages, :upper_age, :lower_age
  attr_reader :distance, :postcode
  attr_reader :activities
  attr_reader :place_categories
  attr_reader :place_category
  attr_reader :activity_categories
  attr_reader :activity_category
  attr_reader :type
  attr_reader :low_lat, :high_lat, :low_long, :high_long
  attr_reader :age_condition, :sex_condition
  
  def initialize (params, user)
    @params = params
    @sex_condition = ""
    @age_condition = ""
    @place_location_condition = ""
    @activity_category_condition = ""
    @keyword=""
    @ages = []
    @activity_categories = Array.new
    @sex_preferences  = []
    @type = 1
    @low_lat =0.0
    @high_lat =0.0
    @low_long =0.0
    @high_long =0.0
    
    
   
    if params[:search_criteria] != nil
      logger.debug('SEARCH CRITERIA')
      logger.debug(params[:search_criteria])
      logger.debug('SEARCH CRITERIA')
      if params[:search_criteria][:type] != nil
        logger.debug('TYPE')
        logger.debug(params[:search_criteria][:type])
        @type = params[:search_criteria][:type]
      end
      
      
      
      if params[:search_criteria][:lower_age] != nil &&  params[:search_criteria][:upper_age] != nil
        logger.debug('HAS PARAMETER AGES')
        logger.debug(params[:search_criteria][:lower_age])
        lower =   params[:search_criteria][:lower_age].to_i
        upper =   params[:search_criteria][:upper_age].to_i
        (lower..upper).each do |age|
          @ages << age
          logger.debug('AGES')
          logger.debug(ages)
        end
      end
      
      if params[:search_criteria][:sex_preference] != nil
        #todo: both
        @sex_preferences << params[:search_criteria][:sex_preference]
      end
      params[:search_criteria].each do |p|
        @ages << p[1] if p[0].to_s.rindex('age_') != nil
        @activity_categories << p[1] if p[0].to_s.rindex('ac_') != nil
        @sex_preferences << p[1]  if p[0].to_s.rindex('sp_') != nil 
      end

      if params[:search_criteria][:keyword] != nil && params[:search_criteria][:keyword] != 'Enter keyword'
        @keyword = params[:search_criteria][:keyword]
      end
      if params[:search_criteria][:type] != nil 
        @type = params[:search_criteria][:type]
      end
      
      @sex = user.sex
      
      if  params[:search_criteria][:distance] != nil 
        @distance =  params[:search_criteria][:distance]
      end

      @place_category = 0
      @activity_category = 0
      if params[:search_criteria][:postcode] != nil
        @postcode = params[:search_criteria][:postcode]
      end
    else
      @sex_condition = ""
      @sex = user.sex
      @age_condition = ""
      @place_location_condition = ""
      @activity_category_condition = ""
      @keyword=""
      @ages = [user.age_preference - 1, user.age_preference, user.age_preference + 1]
      @activity_categories = Array.new
      @sex_preference  = user.sex_preference
      @sex_preferences  = [user.sex_preference.to_s]
      @type = 1
      @low_lat =0.0
      @high_lat =0.0
      @low_long =0.0
      @high_long =0.0
      @upper_age = user.age_preference + 1
      @lower_age = user.age_preference - 1
      
    end
    
  end
  
  def set_age_condition()
    if @ages.length!=0
      s = ""
      @ages.each {|e| s+=e.to_s+','}
      @age_condition =  "age in( " + s.chomp(',') + ")"
    else
      @age_condition =  "1=0"
    end
  end

  def set_gender_condition()
    if @sex_preferences.length!=0 
      s = ""
      @sex_preferences.each {|e| s+=e.to_s+','}
      @sex_condition =  "sex in( " + s.chomp(',') + ")"
    end
  end

  def set_activity_category_condition()
    if @activity_categories.length!=0 
      s = ""
      @activity_categories.each {|e| s+=e.to_s+','}
      @activity_category_condition = "activity_category_id in( " + s.chomp(',') + ")"
    end
  end


  def set_place_location_condition()
    #check postcode exists and is valid UK code
    condition = ""
    if @params[:search_criteria]!= nil && @params[:search_criteria][:distance] != nil && @params[:search_criteria][:distance].to_s != "0" && @params[:search_criteria][:distance].to_s != ""
      distance = @params[:search_criteria][:distance]
      #refactor to use mySQL location datatype
      geocoder = Graticule.service(:google).new "ABQIAAAAZ5MZiTXmjJJnKcZewvCy7RQvluhMgQuOKETgR22EPO6UaC2hYxT6h34IW54BZ084XTohEOIaUG0fog"
      if @params[:search_criteria][:postcode] != nil
        postcode = @params[:search_criteria][:postcode]
        location = geocoder.locate('london ' + postcode)
        latitude, longitude = location.coordinates
        if latitude != nil && longitude != nil
          lat_range = @params[:search_criteria][:distance].to_i / ((6076.00 / 5280.00) * 60.00)
          long_range = @params[:search_criteria][:distance].to_i / (((Math.cos(latitude * 3.141592653589 / 180.00) * 6076.00) / 5280.00) * 60.00)
          @low_lat = latitude - lat_range
          @high_lat = latitude + lat_range
          @low_long = longitude - long_range
          @high_long = longitude + long_range
          condition = "latitude <= " +@high_lat.to_s  + " and latitude >= " +@low_lat.to_s  + " and longitude >= " +@low_long.to_s  + " and longitude <= " +@high_long.to_s
        end
      end
    end
    @place_location_condition = condition
  end

  def conditions
    conditions = ""
    set_age_condition
    set_gender_condition 
    set_activity_category_condition
    set_place_location_condition
    

    if @sex_condition.length>0
      conditions += @sex_condition 
      conditions += " and "
    end
    if @age_condition.length>0
      conditions += @age_condition 
      conditions += " and "  
    end
    if  @activity_category_condition.length>0
      conditions += @activity_category_condition 
      conditions += " and "  
    end
    if @place_location_condition.length>0
      conditions += @place_location_condition 
      conditions += " and "    
    end
    return [@sex_condition.length>0, @age_condition.length>0, @place_location_condition.length>0, @activity_category_condition.length>0, conditions.chomp(" and ")]
  end

end
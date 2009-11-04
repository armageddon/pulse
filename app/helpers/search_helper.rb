module SearchHelper

def self.get_age_conditions(params)
   use_age = 0
   ages = Array.new
   age_string = ""
   if(params[:age_COLLEGE] == "1") 
      ages << 1
      age_string += "1,"
      use_age = 1
    end
    if(params[:age_EARLY_TWENTIES] == "1")
      ages << 2
      age_string += "2,"
      use_age = 1
    end
    if(params[:age_MID_TWENTIES] == "1")
      ages << 3
      age_string += "3,"
      use_age = 1
    end
    if(params[:age_LATE_TWENTIES] == "1")
      ages << 4
      age_string += "4,"
      use_age = 1
    end
    if(params[:age_EARLY_THIRTIES] == "1")
      ages << 5
      age_string += "5,"
      use_age = 1
    end
    if(params[:age_MID_THIRTIES] == "1")
      ages << 6
      age_string += "6,"
      use_age = 1
    end
    if(params[:age_LATE_THIRTIES] == "1")
      ages << 7
      age_string += "7,"
      use_age = 1
    end
    if(params[:age_EARLY_FORTIES] == "1")
      ages << 8
      age_string += "8,"
      use_age = 1
    end
    if(params[:age_MID_FORTIES] == "1")
      ages << 9
      age_string += "9,"
      use_age = 1
    end
    if(params[:age_LATE_FORTIES] == "1")
      ages << 10
      age_string += "10,"
      use_age = 1
    end
    if(params[:age_OLDER] == "1")
      ages << 11
      age_string += "11,"
      use_age = 1
    end
    if age_string.length==0 
      return ""
    else
      return "age in (" + age_string.chomp(",") + ")"
    end
end

def self.get_gender_conditions(params)
  sex_string = ""
  if(params[:gender_MALE].present? && params[:gender_MALE] == "1") 
    sex_string += "1,"
  end
  if(params[:gender_FEMALE].present? && params[:gender_FEMALE] == "1") 
    sex_string += "2,"
  end
  if sex_string.length==0 
    return ""
  else
    return "sex in (" + sex_string.chomp(",") + ")"
  end
end

def self.get_activity_conditions(params)
  activity_string = ""
  if(params[:ac_ART_AND_ENTERTAINMENT_AND_CULTURE].present? && params[:ac_ART_AND_ENTERTAINMENT] == "1") 
    activity_string += "1,"
    use_activity = 1
  end
  if(params[:ac_BUSINESS_AND_CAREER].present? && params[:ac_BUSINESS_AND_CAREER] == "1") 
    activity_string += "2,"
  end
  if(params[:ac_COMMUNITY_AND_LIFESTYLE].present? && params[:ac_COMMUNITY_AND_LIFESTYLE] == "1") 
    activity_string += "3,"
  end
  if(params[:ac_EATING_AND_DRINKING].present? && params[:ac_EATING_AND_DRINKING] == "1") 
    activity_string += "4,"
  end
  if(params[:ac_HEALTH_AND_FITNESS].present? && params[:ac_HEALTH_AND_FITNESS] == "1") 
    activity_string += "5,"
  end
  if(params[:ac_PETS_AND_ANIMALS].present? && params[:ac_PETS_AND_ANIMALS] == "1") 
    activity_string += "6,"
  end
  if(params[:ac_SPORTS].present? && params[:ac_SPORTS] == "1") 
    activity_string += "7,"
  end
  if(params[:ac_TRAVEL].present? && params[:ac_TRAVEL] == "1") 
    activity_string += "8,"
  end
  if activity_string.length==0 
    return ""
  else
    return "activity_category_id in (" + activity_string.chomp(",") + ")"
  end
end

def self.get_place_location_conditions(params)
  #check postcode exists and is valid UK code
  condition = ""
  if params[:distance].to_s != "0" && params[:distance] != nil
    distance = params[:distance]
    postcode = params[:postcode]
    geocoder = Graticule.service(:google).new "ABQIAAAAZ5MZiTXmjJJnKcZewvCy7RQvluhMgQuOKETgR22EPO6UaC2hYxT6h34IW54BZ084XTohEOIaUG0fog"
    if   params[:postcode] != nil && params[:distance] != nil
      location = geocoder.locate('london ' + params[:postcode])
      latitude, longitude = location.coordinates
      if latitude != nil && longitude != nil
        lat_range = params[:distance].to_i / ((6076.00 / 5280.00) * 60.00)
        long_range = params[:distance].to_i / (((Math.cos(latitude * 3.141592653589 / 180.00) * 6076.00) / 5280.00) * 60.00)
        low_lat = latitude - lat_range
        high_lat = latitude + lat_range
        low_long = longitude - long_range
        high_long = longitude + long_range
        condition = "latitude <= " +high_lat.to_s  + " and latitude >= " +low_lat.to_s  + " and longitude >= " +low_long.to_s  + " and longitude <= " +high_long.to_s
      end
    end
  end
  return condition
end

def get_time_conditions
  
end

def self.get_conditions(params)
  use_age = false
  use_sex = false
  use_place_location = false
  use_activity = false
  
  conditions = ""
  sex_condition = get_gender_conditions(params)
  age_condition = get_age_conditions(params)
  place_location_condition = get_place_location_conditions(params)
  activity_condition = get_activity_conditions(params)
  
  if sex_condition != nil and sex_condition.length>0
    conditions += sex_condition 
    conditions += " and "
    use_sex = true
  end
  if age_condition != nil and age_condition.length>0
    conditions += age_condition 
    conditions += " and " 
    use_age = true   
  end
  if activity_condition != nil and activity_condition.length>0
    conditions += activity_condition 
    conditions += " and " 
    use_activity = true   
  end
  
  if place_location_condition != nil and place_location_condition.length>0
    conditions += place_location_condition 
    conditions += " and "    
    use_place_location = true
  end
  return [use_age, use_sex, use_place_location, use_activity, conditions.chomp(" and ")]
end

end
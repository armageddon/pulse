module OptionsHelper

  def age_options
    [
      ["Early twenties", User::Age::EARLY_TWENTIES],
      ["Mid twenties", User::Age::MID_TWENTIES],
      ["Late twenties", User::Age::LATE_TWENTIES],
      ["Early thirties", User::Age::EARLY_THIRTIES],
      ["Mid thirties", User::Age::MID_THIRTIES],
      ["Late thirties", User::Age::LATE_THIRTIES],
      ["Early forties", User::Age::EARLY_FORTIES],
      ["Mid forties", User::Age::MID_FORTIES],
      ["Late forties", User::Age::LATE_FORTIES],
      ["Older", User::Age::OLDER]
    ]
  end
  
  def dotw_options
    [
      ["Monday", 1],
      ["Tuesday", 2],
      ["Wednesday", 3],
      ["Thursday", 4],
      ["Friday", 5],
      ["Saturday", 6],
      ["Sunday", 7]
    ]
  end
  
  def dotw(day_of_week)
    case day_of_week
      when 0 then "Any day"
      when 1 then "Monday"
      when 2 then "Tuesday"
      when 3 then "Wednesday"
      when 4 then "Thursday"
      when 5 then "Friday"
      when 6 then "Saturday"
      when 7 then "Sunday"
     end
end
    def tod(time_of_day)
      case time_of_day
        when 0 then "Any Time"
        when 1 then "Early Mornings"
        when 2 then "Mid Mornings"
        when 3 then "Late Mornings"
        when 4 then "Midday"
        when 5 then "Afternoons"
        when 6 then "Late Afternoons"
        when 7 then "Evenings"
        when 8 then "Late Nights"
       end
  end  
  
  def tod_options
    [
      ["Early Mornings",1], 
      ["Mid Mornings",2],
      ["Late Mornings",3],
      ["Midday",4],
      ["Afternoons",5],
      ["Late Afternoons",6],
      ["Evenings",7],
      ["Late Nights",8]
    ]
  end
  
  def distance_options
    [
      ['1 mile', 1],
      ['2 miles', 2],
      ['5 miles', 5],
      ['10 miles', 10]
    ]
  end
  
  def place_category_options
    options = Array.new
    PlaceCategory.find(:all, :order => "description asc").each do |op| 
      options << [op.description.to_s,op.id.to_s]
    end 
    return options
  end
  
  def activity_category_options
    options = Array.new
    ActivityCategory.find(:all, :order => "description asc").each do |op| 
      options << [op.description.to_s,op.id.to_s]
    end 
    return options
  end
end

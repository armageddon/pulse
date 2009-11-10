module OptionsHelper

  def age_options
    [
      ["College age", User::Age::COLLEGE],
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

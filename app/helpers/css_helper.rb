module CssHelper
  
  def search_keyword_class(search_type)
    case search_type
      when "1" then 'criteria_highlight'
      when "2" then 'criteria_highlight'
      when "3" then 'criteria_highlight'
      when "4" then ''
      else ''
    end
  end
  def search_people_class(search_type)
    case search_type
      when "1" then 'criteria_highlight'
      when "2" then ''
      when "3" then ''
      when "4" then 'criteria_highlight'
      else ''
    end
  end
  def search_places_class(search_type)
    case search_type
      when "1" then ''
      when "2" then 'criteria_highlight'
      when "3" then ''
      when "4" then 'criteria_highlight'
      else ''
    end
  end
  def search_activities_class(search_type)
    case search_type
      when "1" then ''
      when "2" then ''
      when "3" then 'criteria_highlight'
      when "4" then 'criteria_highlight'
      else ''
    end
  end
  
end
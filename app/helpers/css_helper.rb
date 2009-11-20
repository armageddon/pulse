module CssHelper
  
  def search_people_results_class(search_type)
    case search_type
       when "1" then 'criteria_hide'
       when "2" then 'criteria_hide'
       when "3" then 'criteria_hide'
       when "4" then 'criteria_show'
       when "5" then 'criteria_hide'
       else ''
     end
  end
  def search_object_results_class(search_type)
    case search_type
       when "1" then 'criteria_show'
       when "2" then 'criteria_show'
       when "3" then 'criteria_show'
       when "4" then 'criteria_hide'
       when "5" then 'criteria_hide'
       else ''
     end
  end
  def search_activity_results_class(search_type)
    case search_type
       when "1" then 'criteria_hide'
       when "2" then 'criteria_hide'
       when "3" then 'criteria_hide'
       when "4" then 'criteria_show'
       when "5" then 'criteria_hide'
       else ''
     end
  end
  def search_map_results_class(search_type)
    case search_type
       when "1" then 'criteria_hide'
       when "2" then 'criteria_hide'
       when "3" then 'criteria_hide'
       when "4" then 'criteria_hide'
       when "5" then 'criteria_show'
       else ''
     end
  end
  
  
  
  
  
  
  
  
  def search_keyword_class(search_type)
    case search_type
      when "1" then 'criteria_show'
      when "2" then 'criteria_show'
      when "3" then 'criteria_show'
      when "4" then 'criteria_hide'
      when "5" then 'criteria_hide'
      else ''
    end
  end
  def search_people_class(search_type)
    case search_type
      when "1" then 'criteria_show'
      when "2" then 'criteria_hide'
      when "3" then 'criteria_hide'
      when "4" then 'criteria_show'
      when "5" then 'criteria_show'
      else ''
    end
  end
  def search_places_class(search_type)
    case search_type
      when "1" then 'criteria_hide'
      when "2" then 'criteria_show'
      when "3" then 'criteria_hide'
      when "4" then 'criteria_show'
      when "5" then 'criteria_show'
      else ''
    end
  end
  def search_activities_class(search_type)
    case search_type
      when "1" then 'criteria_hide'
      when "2" then 'criteria_hide'
      when "3" then 'criteria_show'
      when "4" then 'criteria_show'
      when "5" then 'criteria_show'
      else ''
    end
  end
  
  
  def search_type_simple_class(search_type)
    case search_type
      when "1" then 'search_type_selected'
      when "2" then 'search_type_selected'
      when "3" then 'search_type_selected'
      when "4" then 'search_type'
      when "5" then 'search_type'
      else ''
    end
  end
  def search_type_advanced_class(search_type)
    case search_type
      when "1" then 'search_type'
      when "2" then 'search_type'
      when "3" then 'search_type'
      when "4" then 'search_type_selected'
      when "5" then 'search_type'
      else ''
    end
  end
  def search_type_map_class(search_type)
    case search_type
      when "1" then 'search_type'
      when "2" then 'search_type'
      when "3" then 'search_type'
      when "4" then 'search_type'
      when "5" then 'search_type_selected'
      else ''
    end
  end
end
require 'test_helper'

class SearchHelperTest < ActionView::TestCase
  
  def test_get_age_conditions
    params = {}
    params[:age_MID_TWENTIES] = "1"
    puts(params)
    condition = SearchHelper.get_age_conditions(params)
    puts(condition)

    assert(condition=="age in (3)")
  end
  
  def test_get_gender_conditions
    params = {}
    params[:gender_MALE] = "1"
    puts(params)
    condition = SearchHelper.get_gender_conditions(params)
    puts(condition)
    assert(condition=="sex in (1)")
  end
  
  def test_get_place_location_conditions
    params = {}
    params[:distance] = 1
    params[:postcode] = 'W8 6QA'
    condition = SearchHelper.get_place_location_conditions(params)
    puts condition
    assert(condition.length>0)
  end  
  
  
end

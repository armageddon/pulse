require 'test_helper'

class PlaceTest < ActiveSupport::TestCase
  # Replace this with your real tests.
 
    def test_place_activities
      @place = Place.find(5215)
      @place_activities = @place.place_activities
      assert_not_equal(@place_activities.length, 0, 'Should be greater than 0')
 
    end
     
end


require 'test_helper'

class UserPlaceTest < ActiveSupport::TestCase
  
  test "requires user and place" do
    user_place = UserPlace.make_unsaved(:user_id => nil, :place_id => nil)
    assert !user_place.valid?
    assert user_place.errors.on(:user_id)
  end
  
  test "requires unique user and place" do
    up = UserPlace.make
    user_place = UserPlace.make_unsaved(:user_id => up.user_id, :place_id => up.place_id)
    assert !user_place.valid?
    assert user_place.errors.on(:user_id)
  end
  
  test "requires description" do
    user_place = UserPlace.make
    user_place.description = nil
    assert !user_place.valid?
    assert user_place.errors.on(:description)
    user_place.description = "a description"
    assert user_place.valid?
    
  end
  
  test "requires user classificaiton" do
    user_place = UserPlace.make
    user_place.classification = nil
    assert !user_place.valid?
    user_place.classification = Classification.make
    assert user_place.valid?
  end
  

end

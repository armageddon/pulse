require 'test_helper'

class PlaceTest < ActiveSupport::TestCase
  
  test "requires name" do
    p = Place.make_unsaved(:name => nil)
    assert !p.valid?
    assert p.errors.on(:name)
  end
  
end

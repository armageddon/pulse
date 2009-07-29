require 'test_helper'

class ClassificationTest < ActiveSupport::TestCase
  
  test "requires name" do
    c = Classification.make_unsaved(:name => nil)
    assert !c.valid?
    assert c.errors.on(:name)
    
    assert c.name = "hot spot for ladies"
    assert c.valid?
  end
  
end

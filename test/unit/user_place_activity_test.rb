require 'test_helper' 
class UserPlaceActivityTest < ActiveSupport::TestCase 
  
  
  def test_add_user_place_activity
        @francois = User.find(1);
        start_count = TimelineEvent.count
        @user_place_activity = UserPlaceActivity.new(:place_id => 4, :activity_id => 7, :user_id => 42)
        @user_place_activity .save
        end_count = TimelineEvent.count

      assert_not_equal (start_count ,end_count ,"should be unequal")
    
  end
  
end

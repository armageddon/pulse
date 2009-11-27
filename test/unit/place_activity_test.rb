require 'test_helper'

class PlaceActivityTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_upa_vs_pa
      @upa_activities  = UserPlaceActivity.paginate(:select => "user_place_activities.activity_id,user_place_activities.place_id, count(user_id) as users_count", :order => "count(user_id) DESC", :joins => "inner join users on users.id = user_place_activities.user_id",:group => 'user_place_activities.activity_id,user_place_activities.place_id', :page => 1, :per_page => 1000)

        @pa_activities  = UserPlaceActivity.paginate(:select => "user_place_activities.activity_id,user_place_activities.place_id, count(user_id) as users_count", :order => "count(user_id) DESC", :joins => "inner join users on users.id = user_place_activities.user_id",:group => 'user_place_activities.activity_id,user_place_activities.place_id', :page => 1, :per_page => 1000)


      assert_equal(@upa_activities.length ,@pa_activities.length,"should be equal")

  end

    def test_upa_vs_pa_with_places_and_activities
      @upa_activities  = UserPlaceActivity.paginate(:select => "user_place_activities.activity_id,user_place_activities.place_id, count(user_id) as users_count", :order => "count(user_id) DESC", :joins => "inner join users on users.id = user_place_activities.user_id inner join places on user_place_activities.place_id = places.id inner join activities on user_place_activities.activity_id = activities.id", :order => "count(user_id) DESC",:group => 'user_place_activities.activity_id,user_place_activities.place_id',:page => 1, :per_page => 1000)

        @pa_activities  = UserPlaceActivity.paginate(:select => "user_place_activities.activity_id,user_place_activities.place_id, count(user_id) as users_count", :order => "count(user_id) DESC", :joins => "inner join place_activities on place_activities.id = user_place_activities.place_activity_id inner join users on users.id = user_place_activities.user_id inner join places on place_activities.place_id = places.id inner join activities on place_activities.activity_id = activities.id", :order => "count(user_id) DESC",:group => 'user_place_activities.activity_id,user_place_activities.place_id',:page => 1, :per_page => 1000)


      assert_equal(@upa_activities.length ,@pa_activities.length,"should be equal")

  end

    def test_create
      place_activity = PlaceActivity.new(:activity_id => 23, :place_id=>45)
      place_activity.save
    end
      def test_users
    place_activity = PlaceActivity.find(:first)
    assert_not_equal(place_activity.users.length,0,'Should be more than one user')
  end
end


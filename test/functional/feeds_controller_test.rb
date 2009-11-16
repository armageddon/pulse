require 'test_helper'

class FeedsControllerTest < ActionController::TestCase
  
  def test_feed
  # Replace this with your real tests.
  @timeline_events = TimelineEvent.all
  assert_not_equal (0,@timeline_events.count, "bleh")
end
end

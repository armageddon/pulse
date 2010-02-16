require File.join( File.dirname(__FILE__), '..', 'spec_helper')

describe UserMatcher do
  
  describe "pct_match" do
    describe "compatible sex preferences" do
      describe "when the two users have nothing in common" do
        it "should return 0.0" do
          load_scenario :users_with_place_activities, :alice_and_dave_with_nothing_in_common
          UserMatcher.pct_match( @alice.id, @dave.id, 'place_activity' ).should == 0.0
        end
      end
      
      describe "when the two users have some things in common" do
        it "should return the pct match" do
          load_scenario :users_with_place_activities, :alice_and_bob_with_two_out_of_four_place_activities_in_common
          UserMatcher.pct_match( @alice.id, @bob.id, 'place_activity' ).should == 50.0
        end
      end
    end
    
    describe "incompatible sex preferences" do
      before(:each) do
        load_scenario :users_with_place_activities, :laura_has_place_activities_in_common_with_bob_but_doesnt_like_men
      end
        
      describe "when user1's sex preference does not match user 2" do
        it "should return 0.0" do
          UserMatcher.pct_match( @laura.id, @bob.id, 'place_activity' ).should == 0.0
        end
      end
      describe "when user2's sex preference does not match user 1" do
        it "should return 0.0" do
          UserMatcher.pct_match( @bob.id, @laura.id, 'place_activity' ).should == 0.0
        end
      end
    end
  end
  
  
  
end

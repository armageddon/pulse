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
  
  describe "matches_for" do
    before(:each) do
      load_scenario :users_with_place_activities, :everyone_with_activities
    end
    
    it "should return an array of users" do
      matches = UserMatcher.matches_for(@alice, 'place_activity', 10)
      matches.each do |match|
        match.class.should == User
      end
    end
    
    describe "returned array" do
      it "should add a match_pct attribute on to each user" do
        matches = UserMatcher.matches_for(@alice, 'place_activity', 10)
        matches.each do |match|
          match.should respond_to(:pct_match)
        end
      end
      
      it "should be in descending order of match pct" do
        prev_match = 100.0
        matches = UserMatcher.matches_for(@alice, 'place_activity', 10)
        matches.each do |match|
          match.pct_match.should <= prev_match
          prev_match == match.pct_match
        end
      end
      
      it "should only have a max of (limit) users" do
        matches = UserMatcher.matches_for(@charlotte, 'place_activity', 10)
        matches.size.should == 2
        matches = UserMatcher.matches_for(@charlotte, 'place_activity', 1)
        matches.size.should == 1
      end
    end
    
    describe "sex preferences" do
      it "should not include users whose sex preferences do not match the given users sex" do
        matches = UserMatcher.matches_for(@laura, 'place_activity', 10)
        matches.each do |m|
          m.sex_preference.should_not == User::Sex::MALE
        end
        
        matches = UserMatcher.matches_for(@bob, 'place_activity', 10)
        matches.each do |m|
          m.sex_preference.should_not == User::Sex::FEMALE
        end
        
        matches = UserMatcher.matches_for(@alice, 'place_activity', 10)
        matches.each do |m|
          m.sex_preference.should_not == User::Sex::MALE
        end
      end
      
      it "should not include users whose sex doesn't match the given users sex preferences" do
        matches = UserMatcher.matches_for(@laura, 'place_activity', 10)
        matches.each do |m|
          m.sex.should == User::Sex::FEMALE
        end
        
        matches = UserMatcher.matches_for(@bob, 'place_activity', 10)
        matches.each do |m|
          m.sex.should == User::Sex::FEMALE
        end
        
        matches = UserMatcher.matches_for(@alice, 'place_activity', 10)
        matches.each do |m|
          m.sex.should == User::Sex::MALE
        end
      end
    end
    
  end
end

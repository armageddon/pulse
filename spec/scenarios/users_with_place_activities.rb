class UsersWithPlaceActivities
  def london
    @london = Location.create(:name=>'london')
  end
  
  def alice
    london 
    @alice = User.new( :username=>"alice", :first_name=>'alice', :last_name=>'abbaba', :email=>'alice@some.com', :location_id=>@london.id, :sex=>User::Sex::FEMALE, :sex_preference=>User::Sex::MALE, :password=>'password', :password_confirmation=>'password', :postcode=>'N2 8AS')
    @alice.stub!(:welcome_mail)
    @alice.save!
  end
  
  def bob
    london 
    @bob = User.new( :username=>"bob", :first_name=>'bob', :last_name=>'blob', :email=>'bob@some.com', :location_id=>@london.id, :sex=>User::Sex::MALE, :sex_preference=>User::Sex::FEMALE, :password=>'password', :password_confirmation=>'password', :postcode=>'NW6 7HB')
    @bob.stub!(:welcome_mail)
    @bob.save!
  end
  
  def dave
    london
    @dave = User.new( :username=>"dave", :first_name=>'dave', :last_name=>'david', :email=>'dave@some.com', :location_id=>@london.id, :sex=>User::Sex::MALE, :sex_preference=>User::Sex::BOTH, :password=>'password', :password_confirmation=>'password', :postcode=>'N11 3PY')
    @dave.stub!(:welcome_mail)
    @dave.save!
  end
  
  
  def place_activities
    london
    @the_castle,  @the_westway, @the_brownswood,  @the_bald_faced_stag, @the_disco = [
      Place.new(:name=>"The Castle", :location => @london),
      Place.new(:name=>"The Westway", :location=> @london),
      Place.new(:name=>"The Brownswood", :location=> @london),
      Place.new(:name=>"The Bald Faced Stag", :location=> @london),
      Place.new(:name=>"The Disco", :location=>@london)
    ].save!
    
    @drinking, @climbing, @badminton, @dancing = [
      Activity.new(:name=>"drinking"),
      Activity.new(:name=>"climbing"),
      Activity.new(:name=>"badminton"),
      Activity.new(:name=>"dancing")
    ].save!
    
    @climbing_at_the_castle,@climbing_at_the_westway,@badminton_at_the_westway, 
    @drinking_at_the_brownswood, @drinking_at_the_bald_faced_stag, @dancing_at_the_disco = [
      PlaceActivity.new(:place=>@the_castle, :activity=>@climbing),
      PlaceActivity.new(:place=>@the_westway, :activity=>@climbing),
      PlaceActivity.new(:place=>@the_westway, :activity=>@badminton),
      
      PlaceActivity.new(:place=>@the_brownswood, :activity=>@drinking),
      PlaceActivity.new(:place=>@the_bald_faced_stag, :activity=>@drinking),
      
      PlaceActivity.new(:place=>@the_disco, :activity=>@dancing)
    ].save!
  end
  
  def alice_with_four_place_activities
    [@climbing_at_the_westway, @badminton_at_the_westway, @drinking_at_the_bald_faced_stag, @dancing_at_the_disco ].each do |pa|
      puts "pa = #{pa.inspect}"
      UserPlaceActivity.new(:place => pa.place, :activity=>pa.activity, :place_activity=>pa, :user=>@alice ).save
    end
  end
  
  def bob_with_four_place_activities
    [@climbing_at_the_westway, @climbing_at_the_castle, @drinking_at_the_brownswood, @dancing_at_the_disco ].each do |pa|
      UserPlaceActivity.new(:place => pa.place, :activity=>pa.activity, :place_activity=>pa, :user=>@bob ).save
    end
  end
  
  
  
  def alice_and_bob_with_two_out_of_four_place_activities_in_common
    alice
    bob
    place_activities
    alice_with_four_place_activities
    bob_with_four_place_activities
  end
  
  def alice_and_dave_with_nothing_in_common
    alice_with_four_place_activities
    dave
  end
  
end

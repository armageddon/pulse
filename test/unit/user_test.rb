require 'test_helper'

class UserTest < ActiveSupport::TestCase
  include AuthenticatedTestHelper

  test "machinist" do
    user = User.make_unsaved
    assert user.valid?
  end

  test "requires username" do
    user = User.make_unsaved(:username => nil)
    assert !user.valid?
    assert user.errors.on(:username)
  end

  test "requires unique username" do
    assert User.make(:username => "dustym")
    user = User.make_unsaved(:username => "dustym")
    assert !user.valid?
    assert user.errors.on(:username)
    
    user.username = "dustym1"
    assert user.valid?
  end

  test "requires email" do
    user = User.make_unsaved(:email => nil)
    assert !user.valid?
    assert user.errors.on(:email)
  end

  test "requires unique email" do
    assert User.make(:email => "dustym@gmail.com")
    user = User.make_unsaved(:email => "dustym@gmail.com", :username => "someotherdusty")
    assert !user.valid?
    assert user.errors.on(:email)
    
    user.email = "dusty@curbed.com"
    assert user.valid?
  end

  test "requires first name" do
    user = User.make_unsaved(:first_name => nil)
    assert !user.valid?
    assert user.errors.on(:first_name)
    
    user.first_name = "dusty"
    assert user.valid?
  end

  test "requires age" do
    user = User.make_unsaved(:age => nil)
    assert !user.valid?
    assert user.errors.on(:age)
    
    user.age = User::Age::COLLEGE
    assert user.valid?
  end

  test "requires age be a valid value" do
    user = User.make_unsaved(:age => 10000)
    assert !user.valid?
    assert user.errors.on(:age)
    
    user.age = User::Age::COLLEGE
    assert user.valid?
  end

  test "requires sex" do
    user = User.make_unsaved(:sex => nil)
    assert !user.valid?
    assert user.errors.on(:sex)
    
    user.sex = User::Sex::MALE
    assert user.valid?
  end

  test "requires valid sex" do
    user = User.make_unsaved(:sex => -1)
    assert !user.valid?
    assert user.errors.on(:sex)
    
    user.sex = User::Sex::FEMALE
    assert user.valid?
  end

  test "requires sex_preference" do
    user = User.make_unsaved(:sex_preference => nil)
    assert !user.valid?
    assert user.errors.on(:sex_preference)
  end

  test "requires valid sex_preference" do
    user = User.make_unsaved(:sex_preference => 11)
    assert !user.valid?
    assert user.errors.on(:sex_preference)
  end

  test "requires age_preference" do
    user = User.make_unsaved(:age_preference => nil)
    assert !user.valid?
    user.age_preference = User::Age::COLLEGE
    assert user.valid?
  end

  test "requires valid age preference" do
    user = User.make_unsaved(:age_preference => -1)
    assert !user.valid?
    user.age_preference = User::Age::MID_TWENTIES
    assert user.valid?
  end

  test "requires description" do
    user = User.make_unsaved(:description => nil)
    assert !user.valid?
    user.description = "I like cat food."
    assert user.valid?
  end

  test "requires cell" do
    user = User.make_unsaved(:cell => nil)
    assert !user.valid?
    
    user.cell = "4692314767"
    assert user.valid?
  end

  test "requires timezone" do
    user = User.make_unsaved(:timezone => nil)
    assert !user.valid?
    assert user.errors.on(:timezone)
    
    user.timezone = 'Central Time (US & Canada)'
    assert user.valid?
  end

  test "should create user" do
    assert_difference 'User.count' do
      user = User.make
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  test "should initialize activation code on creation" do 
    user = create_user
    user.reload
    assert_not_nil user.activation_code
  end

  test "should create and start in pending state" do
    user = create_user
    user.reload
    assert user.pending?
  end


  test "should require password" do
    assert_no_difference 'User.count' do
      u = create_user(:password => nil)
      assert u.errors.on(:password)
    end
  end

  test "should require password confirmation" do
    assert_no_difference 'User.count' do
      u = create_user(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  test "should reset password" do
    user = create_user
    user.activate!
    user.update_attributes(:password => 'new new password', :password_confirmation => 'new new password')
    assert_equal user, User.authenticate(user.username, 'new new password')
  end

  test "shouldn't reset password" do
    user = create_user(:password => 'new password', :password_confirmation => 'new password')
    user.activate!
    user.update_attributes(:username => 'quentin2')
    assert_equal user, User.authenticate('quentin2', 'new password')
  end

  test "should authenticate user" do
    user = create_user
    user.activate!
    assert_equal user, User.authenticate(user.username, 'new password')
  end

  test "should set remember token" do
    user = create_user
    user.remember_me
    assert_not_nil user.remember_token
    assert_not_nil user.remember_token_expires_at
  end

  test "should unset remember token" do
    user = create_user
    user.remember_me
    assert_not_nil user.remember_token
    user.forget_me
    assert_nil user.remember_token
  end

  test "should remember me for one week" do
    user = create_user
    before = 1.week.from_now.utc
    user.remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil user.remember_token
    assert_not_nil user.remember_token_expires_at
    assert user.remember_token_expires_at.between?(before, after)
  end

  test "should remember me until one week" do
    user = create_user
    time = 1.week.from_now.utc
    user.remember_me_until time
    assert_not_nil user.remember_token
    assert_not_nil user.remember_token_expires_at
    assert_equal user.remember_token_expires_at, time
  end

  test "should remember me default of two weeks" do
    user = create_user
    before = 2.weeks.from_now.utc
    user.remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil user.remember_token
    assert_not_nil user.remember_token_expires_at
    assert user.remember_token_expires_at.between?(before, after)
  end

  test "should register passive user" do
    user = create_user(:password => nil, :password_confirmation => nil)
    assert user.passive?
    user.update_attributes(:password => 'new password', :password_confirmation => 'new password')
    user.register!
    assert user.pending?
  end

  test "should suspend user" do
    user = create_user
    user.suspend!
    assert user.suspended?
  end
  
  test "suspended user should not authenticate" do
    user = create_user(:password => 'new password', :password_confirmation => 'new password')
    user.suspend!
    assert_not_equal user, User.authenticate('quentin', 'new password')
  end

  test "should unsuspend user to active state" do
    user = create_user
    user.activate!
    user.suspend!
    assert user.suspended?
    user.unsuspend!
    assert user.active?
  end

  test "should unsuspend user with nil activation code and activated at to passive state" do
    user = User.make
    user.suspend!
    User.update_all :activation_code => nil, :activated_at => nil
    assert user.suspended?
    user.reload.unsuspend!
    assert user.passive?
  end

  test "should unsuspend user with activation code and nil activated at to pending state" do
    user = User.make
    user.suspend!
    User.update_all :activation_code => 'foo-bar', :activated_at => nil
    assert user.suspended?
    user.reload.unsuspend!
    assert user.pending?
  end

  test "should delete user" do
    user = create_user
    assert_nil user.deleted_at
    user.delete!
    assert_not_nil user.deleted_at
    assert user.deleted?
  end

  protected
  def create_user(options = {})
    record = User.make_unsaved(options)
    record.register! if record.valid?
    record
  end


end

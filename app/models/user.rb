require 'digest/sha1'

class User < ActiveRecord::Base

  define_index do
    indexes username
    indexes first_name
    indexes email
    indexes sex
    indexes age
    # indexes places.name, :as => "places"
    # indexes activities.name, :as => "activities"
  end

  class Age
    COLLEGE        = 1
    EARLY_TWENTIES = 2
    MID_TWENTIES   = 3
    LATE_TWENTIES  = 4
    EARLY_THIRTIES = 5
    MID_THIRTIES   = 6
    LATE_THIRTIES  = 7
    EARLY_FORTIES  = 8
  end

  class Sex
    MALE   = 1
    FEMALE = 2
    BOTH   = 3
  end

  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::AasmRoles

  has_attached_file :icon, 
        :styles => { :thumb => "75x75#", :profile => "160x160#", :large => "640x480>" }, 
        :url => "/:class/:attachment/:id/:style_:filename"

  belongs_to :location

  has_many :favorites
  has_many :places, :through => :favorites
  has_many :user_activities
  has_many :activities, :through => :user_activities

  has_many :events

  has_many :messages, :foreign_key => "recipient_id"
  has_many :sent_messages, :foreign_key => "sender_id", :class_name => "Message"

  has_many :connections
  has_many :requested_connections, :foreign_key => "contact_id", :class_name => "Connection"

  has_many :invitations

  validates_presence_of     :location_id

  validates_presence_of     :username
  validates_length_of       :username,    :within => 3..40
  validates_uniqueness_of   :username
  validates_format_of       :username,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :first_name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :first_name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  validates_inclusion_of :sex_preference, :in => [Sex::MALE, Sex::FEMALE, Sex::BOTH], :allow_blank => true
  validates_inclusion_of :sex, :in => [Sex::MALE, Sex::FEMALE], :allow_blank => true
  validates_inclusion_of [:age, :age_preference], :in => [ Age::COLLEGE, Age::EARLY_TWENTIES, Age::MID_TWENTIES, Age::LATE_TWENTIES , Age::EARLY_THIRTIES, Age::MID_THIRTIES, Age::LATE_THIRTIES, Age::EARLY_FORTIES], :allow_blank => true

  # validates_presence_of :timezone, :description, :cell


  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :username, :email, :first_name, :password, :password_confirmation, :timezone, :description, :age, :age_preference, :sex, :sex_preference, :cell, :location_id, :icon
  attr_accessor :login


  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_in_state :first, :active, :conditions => ["username = ? OR email = ?", login.downcase, login.downcase] # need to get the salt
    if u
      u.login = login
    end
    u && u.authenticated?(password) ? u : nil
  end

  def username=(value)
    write_attribute :username, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def preferred_users
    User.find(:all, :conditions => [
      "sex = ? AND sex_preference = ? AND age in (?) AND age_preference in (?) AND id != ?",
      sex_preference,
      sex,
      [age_preference - 1, age_preference, age_preference + 1],
      [age - 1, age, age + 1],
      id
    ], :include => [:favorites, :activities])
  end

  def to_param
    username
  end

  def name
    first_name
  end

  def suggested_places
    # BIG HACK
    # really, just look for places similar to places you have added
    max_id = Place.find(:first, :order => "id DESC").id
    rand_set = (0..100).collect { rand(max_id.to_i) }
    if places.present?
      Place.find(:all, :conditions => ['id not in (?) AND id in (?)', places.map(&:id), rand_set], :limit => 5 )
    else
      Place.find(:all, :conditions => ['id in (?)', rand_set], :limit => 5)
    end
  end

  def suggested_activities
    Activity.find(:all, :conditions => ['id not in (?)', activities.map(&:id)], :order => "rand()", :limit => 5 )
  end

  def all_messages
    Message.find(:all, :conditions => ['recipient_id = ? OR sender_id = ?', id, id])
  end

  def upcoming_events
    events.find(:all, :conditions => ['when_time >= ?', Time.now], :limit => 6, :order => 'when_time ASC')
  end

  def matches(page=0, per_page=8)
    @matches ||= User.paginate(:all, :conditions => [
      "sex = ? AND sex_preference = ? AND age in (?) AND age_preference in (?) AND id != ?",
      sex_preference,
      sex,
      [age_preference - 1, age_preference, age_preference + 1],
      [age - 1, age, age + 1],
      id
    ], :include => [:favorites, :activities], :page => page, :per_page => per_page)
  end

  def unread_count
    @unread_count ||= messages.count(:conditions => "read_at IS NULL")
  end

  def read_all_messages!
    messages.update_all(["read_at = ?", Time.now], { :read_at => nil})
  end

  protected

    def make_activation_code
        self.deleted_at = nil
        self.activation_code = self.class.make_token
    end


end

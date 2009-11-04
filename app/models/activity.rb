class Activity < ActiveRecord::Base
  
  class ActivityCategory
    ARTS_AND_CULTURE = 1
    BUSINESS_AND_CAREER = 2
    COMMUNITY_AND_LIFESTYLE = 3
    EATING_AND_DRINKING = 4
    HEALTH_AND_FITNESS = 5
    PETS_AND_ANIMALS = 6
    SPORTS = 7
    TRAVEL = 8
  end

  define_index do
    indexes name
  end
  has_attached_file :icon, :styles => { :thumb => "75x75#", :thumb => "160x160#" }, :default_url => "/images/Question.png"
  has_many :user_activities
  has_many :user_place_activities
  has_many :users, :through => :user_activities
  has_many :places, :through => :user_place_activities
  

end


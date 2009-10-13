class Activity < ActiveRecord::Base

  define_index do
    indexes name
  end
  has_attached_file :icon, :styles => { :thumb => "75x75#", :thumb => "160x160#" }, :default_url => "/images/question.png"
  has_many :user_activities
  has_many :user_place_activities
  has_many :users, :through => :user_activities
  has_many :places, :through => :user_place_activities
  

end


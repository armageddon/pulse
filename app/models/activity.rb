class Activity < ActiveRecord::Base

  define_index do
    indexes name
  end

  has_attached_file :icon, :styles => { :thumb => "75x75#", :thumb => "160x160#" }

  has_many :user_activities
  has_many :users, :through => :user_activities

end

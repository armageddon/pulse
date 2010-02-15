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
    has activity_category_id
  end
  has_attached_file :icon, :styles => { :thumb => "75x75#", :thumb => "160x160#" }, :default_url => "/images/Question.png"
  
  has_many :user_place_activities
  has_many :users, :through => :user_place_activities
  has_many :places, :through => :user_place_activities
  belongs_to :activity_categories
  

  def self.search_activities(params, current_user)
    search_criteria = SearchCriteria.new(params, current_user)
    if search_criteria.activity_categories.length > 0
      results = Activity.search(params[:search_criteria][:keyword], :conditions => {:activity_category_id => search_criteria.activity_categories},  :page=>params[:page], :per_page=>14)
    else
      results = Activity.search(params[:search_criteria][:keyword], :page => params[:page], :per_page => 14)
    end
    return results
  end
end


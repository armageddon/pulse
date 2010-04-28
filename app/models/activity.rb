class Activity < ActiveRecord::Base
  
  

  define_index do
    indexes name
    has activity_category_id
  end
  has_attached_file :icon, :styles => { :thumb => "75x75#", :large => "160x160#" },
    :url => "/:class/:attachment/:id/:style_:filename",
    :default_url => "/images/default.png"
  
  validates_uniqueness_of :name

  has_many :place_activities
  has_many :user_place_activities 
  has_many :users, :through => :user_place_activities
  has_many :places, :through => :user_place_activities
  belongs_to :activity_categories
  
  def self.search_activities(params, current_user,per_page = 14)
    search_criteria = SearchCriteria.new(params, current_user)
    logger.debug(p search_criteria)
    if search_criteria.activity_categories.length > 0
      results = Activity.search(params[:search_criteria][:keyword], :conditions => {:activity_category_id => search_criteria.activity_categories},  :page=>params[:page], :per_page=>per_page)
    else
      results = Activity.search(params[:search_criteria][:keyword], :page => params[:page], :per_page => per_page)
    end
    return results
  end
end


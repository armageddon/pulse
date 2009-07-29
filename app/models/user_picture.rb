class UserPicture < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :if => lambda {|p| p.parent_id.blank? }

  before_validation :check_icon_status
  after_save :ensure_only_one_icon

  attr_accessible :icon

  private

  def check_icon_status
    self.icon = true if self.user_id.present? &&
      self.class.count(:conditions => {:user_id => self.user_id }) == 0
  end

  def ensure_only_one_icon
    if self.icon
      self.class.update_all(
        ["icon = ?", false],
        ["user_id = ? AND id != ?", self.user_id, self.id]
      )
    end
  end
end

class Message < ActiveRecord::Base
  belongs_to :sender, :class_name => "User"
  belongs_to :recipient, :class_name => "User"

  validates_presence_of :body, :sender_id, :recipient_id

  def self.between(current_user, other_user)
    find(:all, {
     :conditions => ['sender_id IN (?) AND recipient_id IN (?)', [current_user, other_user], [current_user, other_user]],
     :order => "created_at DESC"
    })
  end

end

class Post < ActiveRecord::Base
  belongs_to :user, :class_name => "User" 

  fires :created, :actor => :user,
                    :on    => :create
  
  
  
end
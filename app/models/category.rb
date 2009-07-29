class Category < ActiveRecord::Base
  validates_presence_of :name, :points, :weight, :type
  has_and_belongs_to_many :places
end

class AddTitleToEvent < ActiveRecord::Migration
  def self.up
      add_column :events, :title, :string
      add_column :events, :allDay, :boolean
      add_column :events, :start, :datetime
      add_column :events, :end, :datetime
      add_column :events, :url, :string
  end

  def self.down
      remove_column :events, :title
      remove_column :events, :allDay
      remove_column :events, :start
      remove_column :events, :end
      remove_column :events, :url
  end
end

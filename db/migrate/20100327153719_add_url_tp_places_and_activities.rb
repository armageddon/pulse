class AddUrlTpPlacesAndActivities < ActiveRecord::Migration
    def self.up

    add_column :activities, :url, :string
  end

  def self.down

    remove_column :activities, :url
  end
end

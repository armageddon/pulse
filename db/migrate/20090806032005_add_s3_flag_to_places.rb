class AddS3FlagToPlaces < ActiveRecord::Migration
  def self.up
    add_column :places, :uploaded_picture_to_s3, :boolean, :default => false
  end

  def self.down
    remove_column :places, :uploaded_picture_to_s3
  end
end

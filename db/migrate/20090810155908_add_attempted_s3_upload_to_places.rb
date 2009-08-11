class AddAttemptedS3UploadToPlaces < ActiveRecord::Migration
  def self.up
    add_column :places, :attempted_s3_upload, :boolean, :default => false
  end

  def self.down
    remove_column :places, :attempted_s3_upload
  end
end

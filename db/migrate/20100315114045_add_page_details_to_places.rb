class AddPageDetailsToPlaces < ActiveRecord::Migration
  def self.up
    add_column :places, :create_user_id, :integer
    add_column :places, :admin_user_id, :integer
    add_column :places, :auth_code, :string
    add_column :places, :fb_page_id, :integer, :limit=>8
    add_column :places, :url, :string
  end

  def self.down
    remove_column :places,:create_user_id
    remove_column :places, :admin_user_id
    remove_column :places, :auth_code
    remove_column :places, :fb_page_id
    remove_column :places, :url
  end
end

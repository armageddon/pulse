class AddExtraFieldsToFbUser < ActiveRecord::Migration
  def self.up
    add_column :fb_users,  :first_name, :string
    add_column :fb_users,   :religion, :string
    add_column :fb_users,   :meeting_for, :string
    add_column :fb_users,   :meeting_sex, :string
    add_column :fb_users,   :cl_country, :string
    add_column :fb_users,   :cl_city, :string
    add_column :fb_users,   :cl_state, :string
    add_column :fb_users,   :cl_id, :integer , :limit=>8
    add_column :fb_users,   :cl_zip, :string
    add_column :fb_users,  :htl_country, :string
    add_column :fb_users,  :htl_city, :string
    add_column :fb_users,  :htl_state, :string
    add_column :fb_users,  :htl_id, :integer , :limit=>8
    add_column :fb_users,  :htl_zip, :string
  end

  def self.down
    remove_column :fb_users,  :first_name
    remove_column :fb_users,   :religion
    remove_column :fb_users,   :meeting_for
    remove_column :fb_users,   :meeting_sex
    remove_column :fb_users,   :cl_country
    remove_column :fb_users,   :cl_city
    remove_column :fb_users,   :cl_state
    remove_column :fb_users,   :cl_id
    remove_column :fb_users,   :cl_zip
    remove_column :fb_users,  :htl_country
    remove_column :fb_users,  :htl_city
    remove_column :fb_users,  :htl_state
    remove_column :fb_users,  :htl_id
    remove_column :fb_users,  :htl_zip
  end
end



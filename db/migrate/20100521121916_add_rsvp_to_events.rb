class AddRsvpToEvents < ActiveRecord::Migration
  def self.up
    add_column :fb_user_events, :rsvp_status, :string
    add_column :fb_user_events, :city, :string
    add_column :fb_user_events, :country, :string
    add_column :fb_user_events, :latitude, :float
    add_column :fb_user_events, :longitude, :float
    add_column :fb_user_events, :state, :string
    add_column :fb_user_events, :street, :string
    add_column :fb_user_events, :event_type, :string
    add_column :fb_user_events, :event_subtype, :string
    add_column :fb_user_events, :start_time, :datetime
    add_column :fb_user_events, :end_time, :datetime
  end

  def self.down
    remove_column  :fb_user_events, :rsvp_status
    remove_column :fb_user_events, :city
    remove_column :fb_user_events, :country
    remove_column :fb_user_events, :latitude
    remove_column :fb_user_events, :longitude
    remove_column :fb_user_events, :state
    remove_column :fb_user_events, :street
    remove_column :fb_user_events, :event_type
    remove_column :fb_user_events, :event_subtype
    remove_column :fb_user_events, :start_time
    remove_column :fb_user_events, :end_time
  end
end

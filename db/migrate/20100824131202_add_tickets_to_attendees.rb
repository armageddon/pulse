class AddTicketsToAttendees < ActiveRecord::Migration
  def self.up

    add_column :attendees,:tickets  , :int

  end

  def self.down

    remove_column :attendees,:tickets

  end
end
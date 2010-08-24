class AddTicketRefToAttendees < ActiveRecord::Migration
  def self.up

    add_column :attendees,:ticket_ref  , :string

  end

  def self.down

    remove_column :attendees,:ticket_ref

  end
end
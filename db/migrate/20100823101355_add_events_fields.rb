class AddEventsFields < ActiveRecord::Migration
  def self.up
    
    add_column :events,:tickets_dispensed, :int
    add_column :events,:tickets_bought, :int
    add_column :events, :ticket_price, :float
  end

  def self.down

    remove_column :events,:tickets_dispensed
    remove_column :events,:tickets_bought
    remove_column :events, :ticket_price, :float
  end
end

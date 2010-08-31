class AddGenderTicketsToEventAndTicket < ActiveRecord::Migration
  def self.up
    add_column :tickets,:quantity_male  , :integer
    add_column :tickets,:quantity_female  , :integer
    add_column :events, :tickets_dispensed_female, :integer
    add_column :events, :tickets_dispensed_male, :integer
    add_column :events, :tickets_bought_female, :integer
    add_column :events, :tickets_bought_male, :integer
  end

  def self.down
    remove_column :tickets,:quantity_male
    remove_column :tickets,:quantity_female
    remove_column :events, :tickets_dispensed_female
    remove_column :events, :tickets_dispensed_male
    remove_column :events, :tickets_bought_female
    remove_column :events, :tickets_bought_male
  end
end
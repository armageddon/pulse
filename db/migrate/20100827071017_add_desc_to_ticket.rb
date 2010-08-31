class AddDescToTicket < ActiveRecord::Migration
  def self.up
    add_column :tickets,:description  , :string

  end

  def self.down
    remove_column :tickets,:description
  end
end
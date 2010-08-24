class CreateTicketsTable < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.integer  :event_id, :limit => 8
      t.integer  :user_id
      t.string    :pp_ref
      t.string    :quantity
      t.float      :price
      t.integer         :ticket_status
      
      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
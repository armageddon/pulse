class ChangeDataTypeVisitors < ActiveRecord::Migration
  def self.up
       change_table :visitors do |t|
      t.change :fb_user_id , :integer, :limit=>8
    end
  end

  def self.down
  end
end

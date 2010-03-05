class MakeFbPageIdBigInt < ActiveRecord::Migration
  def self.up
    change_table :activities do |t|
      t.change :fb_page_id , :integer, :limit=>8
    end
  end

  def self.down
  end
end

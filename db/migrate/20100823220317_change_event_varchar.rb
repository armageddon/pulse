class ChangeEventVarchar < ActiveRecord::Migration
   def self.up
    change_table :place_activity_events do |t|
      t.change :info_html , :string, :limit=>1000
    end
    change_table :place_activity_events do |t|
      t.change :description , :string, :limit=>1000
    end
  end

  def self.down
  end
end

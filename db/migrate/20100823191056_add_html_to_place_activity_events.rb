class AddHtmlToPlaceActivityEvents < ActiveRecord::Migration
   def self.up

    add_column :place_activity_events,:info_html , :string

  end

  def self.down

    remove_column :place_activity_events,:info_html

  end
end

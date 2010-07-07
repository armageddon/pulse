class CreateVisitorTable < ActiveRecord::Migration
  def self.up
    create_table :visitors do |t|
      t.integer   :fb_user_id
      t.string    :access_token
      t.string    :auth_code
      t.timestamps
    end
  end

  def self.down
    drop_table :visitors
  end
end

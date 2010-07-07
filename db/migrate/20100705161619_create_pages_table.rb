class CreatePagesTable < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer  :page_id, :limit => 8
      t.string    :access_token
      t.integer    :administrator_id , :limit => 8
      t.string    :name
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
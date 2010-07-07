class ChangePagesAdminDatatype < ActiveRecord::Migration
  def self.up
       change_table :pages do |t|
      t.change :administrator_id , :integer, :limit=>8
    end
  end

  def self.down
  end
end

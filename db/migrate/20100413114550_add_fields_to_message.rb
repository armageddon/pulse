class AddFieldsToMessage < ActiveRecord::Migration
  def self.up
     add_column :messages, :message_type, :integer, :default =>0
     add_column :messages, :thread_original_mail_id, :integer
  end

  def self.down
    remove_column :messages, :message_type
    remove_column :messages, :thread_original_mail_id
  end
end

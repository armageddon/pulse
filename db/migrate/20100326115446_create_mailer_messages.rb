class CreateMailerMessages < ActiveRecord::Migration
  def self.up
    create_table :mailer_messages do |t|
      t.integer   :user_id
      t.string    :type
      t.string    :mail_text
      t.timestamps
    end
  end

  def self.down
    drop_table :mailer_messages
  end
end

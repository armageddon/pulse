require 'test_helper'

class UserMessageTest < ActiveSupport::TestCase

  def test_add_user_place_activity

        @francois = User.find(1);
        @jane = User.find(32);
        @message_count_start =  @jane.messages.length
        @message =  @francois.sent_messages.build({:recipient_id=>32,:subject=>'subj',:body=>'body'})
        puts @message.subject
        puts @message.body
        puts @message.sender_id
        puts @message.recipient_id
        @message.save
        @jane = User.find(32);
        @message_count_end =  @jane.messages.length
    

      assert_not_equal (@message_count_start ,@message_count_end ,"should be unequal")
    
  end

  def test_new_user_welcome_message
    @jane = User.find(32);
    @jane.welcome_mail
  end

end

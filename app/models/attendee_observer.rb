class AttendeeObserver < ActiveRecord::Observer

    def logger
    RAILS_DEFAULT_LOGGER
  end


  def after_save(attendee)
    if attendee.attendee_type == 2
      logger.debug('creating event invite message')
      @event = Event.find(attendee.event_id)
      @body = 'Hi ' + User.find(attendee.user_id).first_name + '. ' + User.find(@event.user_id).first_name + ' invited you to ' + @event.title + '. Click <a href = "' + @event.url+'">here</a> to check it out and RSVP'
      @message = User.find(@event.user_id).sent_messages.build(:recipient_id => attendee.user_id,:body=>@body)
      @message.save
     
    end

  end
end
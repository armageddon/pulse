# To change this template, choose Tools | Templates
# and open the template in the editor.

class TicketObserver < ActiveRecord::Observer
 def after_save(ticket)
    #begin
    user=User.find(ticket.user_id)

    UserMailer.deliver_ticket_notification(user , ticket) if ticket.ticket_status == 2
  #  rescue
  #    RAILS_DEFAULT_LOGGER.error('mailer error')
  #  end

  end
end

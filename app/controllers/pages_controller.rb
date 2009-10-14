class PagesController < ApplicationController
  layout "one_column"
  
  def about
  end
  
  def contact
    logger.info('in feedback')
    
    if request.post?
      AdminMailer.deliver_contact("hellopulse@googlemail.com","hellopulse@googlemail.com","sdsdd",)
      logger.info('after send contact');
      redirect_to '/contact?thanks=true'
      return
    end
  end
  
  def terms
  end
end

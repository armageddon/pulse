class PagesController < ApplicationController
 
  
  def about
  end
  
  def contact
    if request.post?
      AdminMailer.deliver_contact("hellopulse@googlemail.com","hellopulse@googlemail.com","sdsdd", params[:feedback][:love], params[:feedback][:change], params[:feedback][:other], current_user.first_name, current_user.id, current_user.email)
      redirect_to '/contact?thanks=true'
      return
    end
  end
  
  def terms
  end
  

end

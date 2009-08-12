class PagesController < ApplicationController
  layout "one_column"
  
  def about
  end
  
  def contact
    
    if request.post?
      AdminMailer.deliver_contact(params[:contact])
      redirect_to '/contact?thanks=true'
      return
    end
  end
  
  def terms
  end
end

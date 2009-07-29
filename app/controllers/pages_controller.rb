class PagesController < ApplicationController
  def about
  end
  
  def contact
    
    if request.post?
      AdminMailer.deliver_contact(params[:contact])
      redirect_to '/contact?thanks=true'
      return
    end
    
    render :layout => "one_column"
  end
  
  def terms
    render :layout => "one_column"
  end
end

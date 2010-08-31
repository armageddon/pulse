class PaymentsController < ApplicationController
  include ActiveMerchant::Billing
before_filter :login_required

  
  def index
    logger.debug(params[:event_id])
    @places = Place.find(:all, :limit=>10)
   
    if params[:event_id].present?
      @event = Event.find(params[:event_id])
      @place_activity_event = PlaceActivityEvent.find_by_place_activity_id(@event.place_activity_id)
    end

  end

  def error
    logger.debug('dddddd')
    @message = "An error has occured with your payment. Please try again later. Our engineers have been notified of the problem"
  end


  def checkout
    if current_user == nil
      render :action => 'error'
      return
    end
    logger.debug(p params)
    price = params[:price]
    quantity_male = params[:quantity_male] || 0 if params[:quantity_male].present?
    quantity_female = params[:quantity_female] || 0 if params[:quantity_female].present?
    quantity = params[:quantity] || 0 if params[:quantity].present?
    event = Event.find(params[:event_id])
    if quantity.to_i !=0
      quantity.to_i  == 1 ? s = '' : s = 's'
      q = quantity.to_i
      description = '%.0f' % q + ' ticket' +s + ' (M:'+quantity_male.to_s+'/F:'+quantity_female.to_s+') to ' + PlaceActivityEvent.find_by_place_activity_id(event.place_activity_id).header + ' on ' + event.start.strftime("%A %d %B %Y %I:%M %p") +'  Price £:'+  '%.2f' % (price.to_i/100)

    else
      quantity_male.to_i + quantity_female.to_i == 1 ? s = '' : s = 's'
      q = quantity_male.to_i + quantity_female.to_i
      description = '%.0f' % q + ' ticket' +s + ' (M:'+quantity_male.to_s+'/F:'+quantity_female.to_s+') to ' + PlaceActivityEvent.find_by_place_activity_id(event.place_activity_id).header + ' on ' + event.start.strftime("%A %d %B %Y %I:%M %p") +'  Price: £'+  '%.2f' %  (price.to_i/100)

      
    end


    setup_response = gateway.setup_purchase(price.to_i,
      :ip                => request.remote_ip,
      :return_url        => url_for(:action => 'confirm', :only_path => false),
      :cancel_return_url => url_for(:action => 'index', :only_path => false),
      :description => description#quantity+ .to_s + ' tickets to ' + PlaceActivityEvent.find_by_place_activity_id(event.place_activity_id).header + ' on ' + event.start.strftime("%A %d %B %Y %I:%M %p") + '     £'+'%.2f' % price
    )
    ticket = Ticket.new()
    ticket.pp_ref = setup_response.token
    ticket.user_id = current_user.id
    ticket.event_id = event.id
    ticket.quantity = quantity
    ticket.quantity_male = quantity_male
    ticket.quantity_female = quantity_female
    ticket.price = price
    ticket.save
    redirect_to gateway.redirect_url_for(setup_response.token)
  end

  def confirm
    ticket = Ticket.find_by_pp_ref(params[:token])
    ticket.ticket_status=2

    @event = Event.find(ticket.event_id)
    @place_activity_event = PlaceActivityEvent.find_by_place_activity_id(@event.place_activity_id)
    details_response = gateway.details_for(params[:token])
    logger.debug(p details_response.params)
    logger.debug(p details_response.params["order_description"])
    @description = details_response.params["order_description"]
    @details = params[:token]
    ticket.description =  @description
    ticket.save
    if !details_response.success?
      @message = details_response.message
      render :action => 'error'
      return
    end

    @address = details_response.address
  end

  def complete
    #check number of tickets left
    ticket = Ticket.find_by_pp_ref(params[:token])
    @event=Event.find(ticket.event_id)
    #if event.tickets_dispensed - event.tickets_bought < ticket.quantity
    #  render :action => 'error'
    # end
    purchase = gateway.purchase(ticket.price,
      :ip       => request.remote_ip,
      :payer_id => params[:payer_id],
      :token    => params[:token]
    )
    @details = purchase.token
    if !purchase.success?
      @message = purchase.message
      render :action => 'error'
      return
    end
    ticket.ticket_status=2
    ticket.save
    
    @event.tickets_bought_female+=ticket.quantity_female.to_i
    @event.tickets_bought_male+=ticket.quantity_male.to_i
    @event.tickets_bought+=ticket.quantity.to_i
    @event.save

    @place_activity_event = PlaceActivityEvent.find_by_place_activity_id(@event.place_activity_id)
    attendee = Attendee.find_by_user_id_and_event_id(ticket.user_id, ticket.event_id)
    attendee= Attendee.new if attendee==nil
    attendee.user_id = ticket.user_id
    attendee.event_id = @event.id
    attendee.attendee_type=1
    attendee.attendee_response = 1
    attendee.save
    #add to atendees
    #change event ticket count
    redirect_to '/user_events/'+@event.id.to_s
  end

  private
  def gateway
    @gateway ||= PaypalExpressGateway.new(
      :login => 'pierre_1282639251_biz_api1.googlemail.com',
      :password => '1282639256',
      :signature => 'Aj1iXwwm1VUc.4leRZdDIhiGSa7lA1qqqstt9nj.sshmsEF2dnNpSW3j'
    )
  end
end

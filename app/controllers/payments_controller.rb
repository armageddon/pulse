class PaymentsController < ApplicationController
  include ActiveMerchant::Billing

  def index
     logger.debug(params[:event_id])
    @places = Place.find(:all, :limit=>10)
   
    if params[:event_id].present?
      @event = Event.find(params[:event_id])
      @place_activity_event = PlaceActivityEvent.find_by_place_activity_id(@event.place_activity_id)
    end

  end

  def checkout
    logger.debug(p params)
    price = params[:price]
    quantity = params[:quantity]
    event = Event.find(params[:event_id])

    setup_response = gateway.setup_purchase(5000,
      :ip                => request.remote_ip,
      :return_url        => url_for(:action => 'confirm', :only_path => false),
      :cancel_return_url => url_for(:action => 'index', :only_path => false),
      :description => quantity.to_s + ' tickets to ' + PlaceActivityEvent.find_by_place_activity_id(event.place_activity_id).header + ' on ' + event.start.to_s + '     £'+price
    )
    ticket = Ticket.new()
    ticket.pp_ref = setup_response.token
    ticket.user_id = current_user.id
    ticket.event_id = event.id
    ticket.quantity = quantity
    ticket.price = price
    ticket.save
    redirect_to gateway.redirect_url_for(setup_response.token)
  end

  def confirm
    ticket = Ticket.find_by_pp_ref(params[:token])
    ticket.ticket_status=2
    ticket.save
    details_response = gateway.details_for(params[:token])
    logger.debug(p details_response.params)
    logger.debug(p details_response.params["order_description"])
    @description = details_response.params["order_description"]
    @details = params[:token]
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
    event=Event.find(ticket.event_id)
    if event.tickets_dispensed - event.tickets_bough < ticket.quantity
      render :action => 'error'
    end
    purchase = gateway.purchase(5000,
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
    
    event.tickets_bought+=ticket.quantity.to_i
    event.save

    attendee = Attendee.find_by_user_id_and_event_id(ticket.user_id, ticket.event_id)
    attendee= Attendee.new if attendee==nil
    attendee.event_id = event.id
    attendee.attendee_type=2
    attendee.attendee_response = 1
    attendee.save
    #add to atendees
    #change event ticket count

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

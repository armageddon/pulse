require 'ping_fm'

class UserPlaceActivityObserver < ActiveRecord::Observer
  def logger
    RAILS_DEFAULT_LOGGER
  end

  def after_save(user_place_activity)
    if(user_place_activity.errors.length==0)
 
      logger.debug('start')
      #check if activity or place has a partner
      if user_place_activity.place.admin_user_id != nil
        url = user_place_activity.place.url||'http://www.hellopulse.com/places/'+user_place_activity.place.id.to_s
      elsif user_place_activity.activity.admin_user_id != nil
        url = user_place_activity.activity.url||'http://www.hellopulse.com/activities/'+user_place_activity.activity.id.to_s
      else
        url = user_place_activity.place.url||'http://www.hellopulse.com/places/'+user_place_activity.place.id.to_s
      end

      message = User.find(user_place_activity.user_id).first_name + ' added ' + Activity.find(user_place_activity.activity_id).name + ' at ' +Place.find(user_place_activity.place_id).name+ ' : ' + user_place_activity.description
      tweet =  message[0,112]+'... '+ url
      begin
        PingFM.user_post("status", tweet)
      rescue
        logger.error('tweet failed')
      end
      #todo : lazy load this
      logger.info('message: ' + message +  'URL: ' + url)
      pulse_fb_session = Facebooker::Session.create
      pulse_fb_session.auth_token = "NH3XTZ" #ZMZ8SM"
      begin
        pulse_fb_session.post("facebook.stream.publish", :action_links=> '[{ "text": "Check out HelloPulse!", "href": "'+url+'"}]', :message => message,  :uid=>279928867967)
      rescue
        logger.error('fb failed')
      end

      

    end
  end
end
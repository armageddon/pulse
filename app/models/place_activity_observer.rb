require 'bitly'

class PlaceActivityObserver < ActiveRecord::Observer
  def logger
    RAILS_DEFAULT_LOGGER
  end

  def after_save(place_activity)
    logger.debug(place_activity.place_id)
    logger.debug(place_activity.id)
    begin
      if place_activity.url == nil && place_activity.id != 0  && place_activity.id != nil
        bitly = Bitly.new('hellopulse','R_84b8e1abe448b0ef0517cea2e1a5eb42')
        long_url = 'http://www.hellopulse.com/place_activities/'+place_activity.id.to_s
        logger.debug(long_url )
        page_url = bitly.shorten(long_url)
        place_activity.url = page_url.shorten
        place_activity.save
      end
    rescue
      logger.error('Place activity URL save error')
      place_activity.url = 'www.bit.ly/atCD0U'
      place_activity.save
    end
  end
end

require 'bitly'

class PlaceObserver < ActiveRecord::Observer
  def logger
    RAILS_DEFAULT_LOGGER
  end

  def after_save(place)
    begin
      if place.url == BITLY_URL && place.id != 0  && place.id != nil
        bitly = Bitly.new('hellopulse','R_84b8e1abe448b0ef0517cea2e1a5eb42')
        long_url = 'http://www.hellopulse.com/places/'+place.id.to_s
        logger.debug(long_url )
        page_url = bitly.shorten(long_url)
        place.url = page_url.shorten
        place.save
      end
    rescue
      logger.error('Place  URL save error')
      place.url =BITLY_URL
      place.save
    end
  end
end

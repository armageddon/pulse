require 'bitly'

class ActivityObserver < ActiveRecord::Observer
  def logger
    RAILS_DEFAULT_LOGGER
  end

  def after_save(activity)
    begin
      if activity.url == nil && activity.id != 0  && activity.id != nil
        bitly = Bitly.new('hellopulse','R_84b8e1abe448b0ef0517cea2e1a5eb42')
        long_url = 'http://www.hellopulse.com/activities/'+activity.id.to_s
        logger.debug(long_url )
        page_url = bitly.shorten(long_url)
        activity.url = page_url.shortens
        activity.save
      end
    rescue
      logger.error(' activity URL save error')
      activity.url =BITLY_URL
      activity.save
    end
  end
end

module DateAndTimeHelper
  
  def self.didwhen(old_time)

    val = Time.now - old_time
    #puts val
    if val < 10 then
      result = 'just a moment ago'
    elsif val < 40  then
      result = 'less than ' + (val * 1.5).to_i.to_s.slice(0,1) + '0 seconds ago'
    elsif val < 60 then
      result = 'less than a minute ago'
    elsif val < 60 * 1.3  then
      result = "1 minute ago"
    elsif val < 60 * 50  then
      result = "#{(val / 60).to_i} minutes ago"
    elsif val < 60  * 60  * 1.4 then
      result = 'about 1 hour ago'
    elsif val < 60  * 60 * (24 / 1.02) then
      result = "about #{(val / 60 / 60 * 1.02).to_i} hours ago"
    else
      result = old_time.strftime("%B %d, %Y")

    end
    result
  end
  
end
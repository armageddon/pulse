module ApplicationHelper

  def attendee_response_string(attendee_response)
    case attendee_response
    when 1
      'ATTENDING'
    when 2
      'MAYBE ATTENDING'
    when 3
      'NOT ATTENDING'
    end
  end
  
  def drop_down(name, value, html_options, select_options, default_target = "Any", default_value = "", id="")
    opts = ""
    target = ""
    if default_value != ""
      opts += "<p>" + default_target + "<span class='hidden_value'>" + default_value.to_s + "</span></p>"
    end
    select_options.each do |opt|
      opts += "<p>" + opt[0] + "<span class='hidden_value'>" + opt[1].to_s + "</span></p>"
      target = opt[0] if opt[1].to_s == value.to_s
    end 
    target = default_target if target.length==0
    %Q(<div class='fancy_select' style="margin-top: 0px; width:#{html_options[:width]}; float:left">
        #{hidden_field_tag name, value}
        <div class="fancy_select_target" id="#{html_options[:id]}_target">
          #{target}
        </div>
  	  <div class="fancy_select_options" style="width:#{html_options[:width]};">
  	    #{opts}     
  	  </div>
  	</div>)
  end
  
  def std_drop_down(name, value, html_options, select_options, default_target = "Any", default_value = "", id="", select_id = "")
    logger.debug('VALUE=' + value.to_s)
    opts = ""
    if default_value != ""
      opts += "<option value=0>" + default_target + "</option>"
    end
    select_options.each do |opt|
      if(opt[1].to_s == value.to_s)
        opts += "<option selected = 'true' value='" + opt[1].to_s + "'>" + opt[0].to_s + "</option>"
      else
        opts += "<option value='" + opt[1].to_s + "'>" + opt[0].to_s + "</option>"
      end
    end
    html_options[:class] ||= "std_dd"
    %Q(#{hidden_field_tag name, value}
    <select  id = "#{select_id}" class=#{html_options[:class]} style="margin-left:#{html_options[:leftmargin]};width:#{html_options[:width]};float:#{html_options[:float]}; ">
  	    #{opts}     
  	  </select>)
  end


  def googlecode(url)
    if url.include? ".co.uk"
      "UA-143478-7"
    else
      "UA-143478-6"
    end
  end
  
  def getmapsapikey(url)
    if Rails.env  != "production"
      'ABQIAAAAZ5MZiTXmjJJnKcZewvCy7RQvluhMgQuOKETgR22EPO6UaC2hYxT6h34IW54BZ084XTohEOIaUG0fog'
    elsif url.include? ".co.uk"
      'ABQIAAAArdqGwpu3b8yNbPBH_W7VcxS0BVhZwctV-i2_A3PM5_4nC4nFLRQFHlODK_zRe2mIOTpRur9m4LFnyA'
    else
      'ABQIAAAArdqGwpu3b8yNbPBH_W7VcxRhKqGJz2XpjEX0yvpoqNJsCS6C3RQc357CAtK1DBmVMWVoj-V1g38HpQ'
    end  
  end
  
  def nav_links
    if logged_in?&&current_user!=nil
    links = Array.new
    links << content_tag(:li,:class=>nav_link_class('')) { link_to "Logout", logout_path }
    links << content_tag(:li,:class=>nav_link_class('user_favorites')) { link_to I18n.translate("my_favorites"), account_favorites_path } if current_user.status ==1
    links <<  content_tag(:li,:class=>nav_link_class('user_messages')) { link_to "My messages#{current_user.unread_count > 0 ? " (#{current_user.unread_count})" : ""}", account_messages_path }
    links <<  content_tag(:li,:class=>nav_link_class('user_matches')) { link_to "My matches", account_matches_path } if current_user.status ==1
    links <<  content_tag(:li,:class=>nav_link_class('users')) { link_to "Home", root_path }
    links.join("")
    elsif request.path_parameters['controller']!= 'users'
     logger.debug('DDDDDDDDDDDDD' + request.path_parameters['controller'])
      render :partial => '/shared/login', :locals=>{:id=>params[:id], :controller=>request.path_parameters['controller'] }


    end
  end

  def nav_link_class(page)
    case page
    when "users"
      controller_name == "users" ? "selected" : ""
    when "user_matches"
      controller_name == "user_matches" ? "selected" : ""
    when "user_messages"
      controller_name == "user_messages" ? "selected" : ""
    when "profile"
      (controller_name == "profiles" && current_user == @user) ? "selected" : ""
    when "user_favorites"
      controller_name == "user_favorites" ? "selected" : ""
    else
      ""
    end
  end
  
  def pagination_name(collection)
    if collection.present?
      case collection.first
      when User
        if controller_name == "matches_controller"
          "matches"
        else
          "people"
        end
      end
    end
  end
  
  def submit_button(text, options={})
    if options[:class] == "" or options[:class] == nil
      c =  'submit'
    else
      c =options[:class]
    end
    %Q(<button  id="#{options[:id]}" class="#{c}" type="submit"style="#{options[:style]}"
      ><span class="submit_text">#{text}</span>
    </button>)
  end
  
  def gender_age_preference(age_preference, gender)
    gender = case gender
    when User::Sex::FEMALE
      "her"
    when User::Sex::MALE
      "his"
    when User::Sex::BOTH
      "his or her"
    end
    
    case age_preference
    when User::Age::COLLEGE
      "#{gender} college years"
    when User::Age::EARLY_TWENTIES
      "#{gender} early 20's"
    when User::Age::MID_TWENTIES
      "#{gender} mid 20's"
    when User::Age::LATE_TWENTIES
      "#{gender} late 20's"
    when User::Age::EARLY_THIRTIES
      "#{gender} early 30's"
    when User::Age::MID_THIRTIES
      "#{gender} mid 30's"
    when User::Age::LATE_THIRTIES
      "#{gender} late 30's"
    when User::Age::EARLY_FORTIES
      "#{gender} early 40's"
    when User::Age::MID_FORTIES
      "#{gender} mid 40's"
    when User::Age::LATE_FORTIES
      "#{gender} late 40's"
    when User::Age::OLDER
      "#{gender} 50's or older"
    end
  end
  
  def gender_preference(gender)
    case gender
    when User::Sex::FEMALE
      "woman"
    when User::Sex::MALE
      "man"
    when User::Sex::BOTH
      "man or woman"
    end
  end
  
  def sex_to_s(gender, options={})
    case gender
    when User::Sex::FEMALE
      options[:female] || "her"
    when User::Sex::MALE
      options[:male] || "his"
    when User::Sex::BOTH
      options[:both] || "his or her"
    end
  end

end

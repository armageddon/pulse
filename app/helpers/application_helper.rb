module ApplicationHelper

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
    return unless logged_in?
    
    [
      content_tag(:span, :class => nav_link_class("users")) { link_to "Home", root_path },
      content_tag(:span, :class => nav_link_class("user_matches")) { link_to "My matches", account_matches_path },
      content_tag(:span, :class => nav_link_class("user_messages")) { link_to "My messages#{current_user.unread_count > 0 ? " (#{current_user.unread_count})" : ""}", account_messages_path },
      content_tag(:span, :class => nav_link_class("user_favorites")) { link_to "My favorites", account_favorites_path },
      content_tag(:span, :class => nav_link_class("profile")) { link_to "My profile", profile_path(current_user) },
      content_tag(:span, :class => "nav_link") { link_to "Logout", logout_path }
    ].join("&nbsp;")
  end

  def nav_link_class(page)
    case page
    when "users"
      controller_name == "users" ? "nav_link on" : "nav_link"
    when "user_matches"
      controller_name == "user_matches" ? "nav_link on" : "nav_link"
    when "user_messages"
      controller_name == "user_messages" ? "nav_link on" : "nav_link"
    when "profile"
     (controller_name == "profiles" && current_user == @user) ? "nav_link on" : "nav_link"
    else
      "nav_link"
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
    %Q(<button class="submit" id="#{options[:id]}" type="submit"
      <span class="submit_text">#{text}</span>
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

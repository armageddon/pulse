ActionController::Routing::Routes.draw do |map|
  map.resources :test3s

  map.messages_admin '/messages/admin', :controller => 'user_messages' , :action => 'admin'
map.facebook_post '/facebook_post', :controller => 'facebook', :action=>'post_from_m'
  #facebook controller
  map.resources :facebook
  map.facebook_serendipity 'facebook_serendipity',  :controller => 'facebook', :action=>'facebook_serendipity'
map.facebook_summary 'facebook_summary',   :controller => 'facebook', :action=>'facebook_summary'
  map.facebook_tab 'facebook/tab',  :controller => 'facebook', :action=>'facebook_tab'
  map.facebook_stats '/facebook_stats',  :controller => 'facebook', :action=>'facebook_stats'
    map.post_to_newsfeed '/facebook_post_to_newsfeed',  :controller => 'facebook', :action=>'post_to_newsfeed'
  map.visitor '/visitor', :controller => 'facebook', :action=>'new_visitor'
  #maps controller
  map.map '/map',  :controller => 'maps', :action => 'index'
  map.big_map '/big_map' , :controller => 'maps', :action => 'map'
  
  #search controller
  map.search_simple '/search/simple', :controller => 'search', :action => "simple"
  map.search_nav '/search/nav', :controller => 'search', :action => "nav"
  map.search_places '/search/places', :controller => 'search', :action => "places"
  map.search_people '/search/people', :controller => 'search', :action => "people"
  map.search_people '/search/people_list', :controller => 'search', :action => "people_list"
  map.search_activities '/search/activities', :controller => "search", :action => "activities"
  map.search_user_place_activities '/search/user_place_activities', :controller => "search", :action => "user_place_activities"
  map.activity_list '/search/activity_list', :controller => 'search', :action => "activity_list" #todo - url doesnt look good
  map.search '/search', :controller => "search", :action => 'index'
  map.search_criteria '/search_criteria',  :controller => "search", :action => 'search_criteria'
  map.map_places '/search/map', :controller => 'search', :action => 'map_places'
   
  #users controller
  map.match_module '/account/match_module', :controller=>'users', :action=>'match_module'
  map.step3 '/new_step3', :controller=>'users', :action=>'new_step3'
  map.update_partner '/update_partner',:controller=>'users', :action=>'update_partner'
  map.edit_partner '/edit_partner', :controller=>'users', :action=>'edit_partner'
  map.add_photo '/add_photo', :controller => 'users', :action=>'add_photo'
  map.invite_fb_friends '/invite_fb_friends', :controller=>'users', :action=>'invite_fb_friends'
  map.facebook_user_exists 'facebook_user_exists' , :controller=>'users', :action=>'facebook_user_exists'
  map.partner_new 'users/partner_new', :controller=>'users', :action=>'partner_new'
  map.quick_reg '/quick_reg', :controller=>'users', :action=>'quick_reg'
  map.partner_reg '/partner_reg', :controller=>'users', :action=>'partner_reg'
  map.partner_registered '/partner_registered', :controller =>'users', :action=>'partner_registered'
  map.linker '/account/do_link' , :controller => 'sessions', :action=>'link'
  map.link_page '/account/link', :controller => 'users', :action => 'link'
  map.link_user_accounts '/account/link_user_accounts', :controller => 'users', :action => 'link_user_accounts'
  map.admin_delete '/admin_delete', :controller => 'users', :action => 'admin_delete'
  map.user_admins '/user_admins', :controller => 'users', :action => 'admin'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.redeem  '/redeem', :controller => "users", :action => 'redeem'
  map.signup '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.user_activity_list '/account/user_place_activities', :controller =>'users', :action => "user_places"
  map.user_place_activities '/account/place_activities' , :controller => 'users', :action => 'place_activity_list'
  map.favorite_people 'favorites/people', :controller => 'users', :action => 'favorites_list'
  map.update '/update', :controller => "users", :action => 'update'
  map.crop '/crop', :controller => "users", :action => 'crop'
  map.icon_crop '/icon_crop', :controller => "users", :action => 'icon_crop'
  map.suggested_places '/account/suggested_places', :controller => 'user_matches', :action => 'suggested_places'
  map.resource :account, :controller => "users" do |u|
    u.resources :favorites, :controller => "user_favorites"
    u.resources :pictures, :controller => "user_pictures"
    u.resources :messages, :controller => "user_messages"
    u.resources :invitations, :controller => "user_invitations"
    u.resources :matches, :controller => "user_matches", :collection => { :all => :get }
    u.resources :activities, :controller => "user_activities"
    u.resources :places, :controller => "user_places"
  end
  
  #sessions controller
  map.partner_auth 'sessions/partner_auth' , :controller=>'sessions', :action => 'partner_auth'
  map.partner '/partner', :controller=>'sessions', :action => 'partner'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.activity_user '/activity_user', :controller => 'sessions', :action=>'activity_user'

  #user_messages controller
  map.inbox '/account/inbox', :controller => 'user_messages', :action => 'index'
  map.meet '/messages/meet', :controller=>'user_messages', :action => 'meet'
  map.meet '/messages/create_meet', :controller=>'user_messages', :action => 'create_meet'

  #pages controller
  map.about '/about', :controller => "pages", :action => 'about'
  map.contact '/contact', :controller => "pages", :action => 'contact'
  map.terms '/terms', :controller => "pages", :action => 'terms'

  map.invite_send '/invites/send' , :controller => "user_invitations", :action => 'sender'
  map.import '/import', :controller => "user_invitations", :action => 'import'
  map.invite '/invite', :controller => "user_invitations", :action => 'invite'
  #feeds controller
  map.feed '/feed', :controller => 'feeds', :action => 'feed'
  
  #place_pictures controller

  #user_events_controller
  map.resources :user_events
  map.user_events '/user/events', :controller=>'user_events', :action=>'user_events'
  map.event_invites '/events/guests_to_invite', :controller=>'user_events', :action=>'guests_to_invite'
  map.event_invites '/events/attendees', :controller=>'user_events', :action=>'attendees'
  map.event_create '/events/create', :controller=>'user_events', :action=>'create'
  map.event_respond '/events/respond', :controller=>'user_events', :action=>'respond'
  #user_favorites controller
  map.user_favorited 'user_favorites/user_favorited', :controller => 'user_favorites',  :action => 'user_favorited'
  map.user_favorite_delete 'account/favorites/delete', :controller => 'user_favorites',  :action => 'destroy'
  map.user_favorite_users '/favorites/users', :controller => 'user_favorites',  :action => 'users'
  map.user_favorite_user_place_activities '/favorites/user_place_activities', :controller => 'user_favorites',  :action => 'user_place_activities'
  
  #user_activities controller
  map.user_activity_delete 'account/activities/delete', :controller => 'user_activities',  :action => 'destroy'

  #user_place_activities controller
  map.user_place_activity '/user_place_activities/free', :controller => "user_place_activities", :action =>"free"
  map.user_place_activity '/user_place_activities', :controller => "user_place_activities", :action =>"show"
  map.delete_place_activity '/user_place_activities/delete', :controller => 'user_place_activities', :action => 'destroy'
  map.favourite_place_activities 'user_place_activities/list', :controller => 'user_place_activities', :action=>'list'
  map.add_user_place_activity 'user_place_activities/add', :controller => 'user_place_activities', :action=>'create'
  map.update_user_place_activity 'user_place_activities/update', :controller => 'user_place_activities', :action=>'update'
  map.update_user_place_activity 'user_place_activities/edit', :controller => 'user_place_activities', :action=>'edit'
  map.new_user_place_activity '/user_place_activities/new_user_place_activity',  :controller => 'user_place_activities', :action=>'new_user_place_activity'
  #place_activities controller
  map.resources :place_activities
  map.place_activity_users '/place_activity/users', :controller => 'place_activities', :action => 'users'
  map.place_activity_user_place_activities '/place_activity/user_place_activities', :controller => 'place_activities', :action => 'user_place_activities'
  
  #places_controller
  map.place_users '/places/info_window',  :controller => 'places', :action => 'info_window'
  map.place_autocomplete_new '/places/autocomplete_new', :controller => 'places', :action => 'autocomplete_new'
  map.activity_admin 'places/admin', :controller=>'places', :action=>'admin'
  map.activity_post_fb 'places/post_to_facebook', :controller=>'places', :action=>'post_activity_to_facebook'
  map.activity_partner 'places/partner' , :controller=>'places', :action=>'partner'
  map.resources :places, :collection => { :autocomplete => :get } do |p|
    p.resources :pictures, :controller => "place_pictures"
  end

  map.place_users '/place/users', :controller => 'places', :action => 'users'
  map.place_user_place_activities '/place/user_place_activities', :controller => 'places', :action => 'user_place_activities'
  
  #activity_controller
  map.activity_post_fb 'activities/post_to_facebook', :controller=>'activities', :action=>'post_activity_to_facebook'
  map.activity_update  'activities/update', :controller=>'activities', :action=>'update'
  map.activity_admin 'activities/admin', :controller=>'activities', :action=>'admin'
  map.activity_partner 'activities/partner' , :controller=>'activities', :action=>'partner'
  map.resources :activities, :collection => { :autocomplete => :get } do |a|
    a.resources :pictures, :controller => "activity_pictures"
  end
  
  map.test_new 'new_test', :controller=>'activities', :action => 'new_test'
  map.test_new 'fb_test', :controller=>'facebook', :action => 'callback'
  map.mail_test 'mail_test', :controller=>'activities', :action => 'mail_test'
  map.activity_users '/activity/users', :controller => 'activities', :action => 'users'
  map.activity_user_place_activities '/activity/user_place_activities', :controller => 'activities', :action => 'user_place_activities'
  map.activity_places '/activity/activity_places',  :controller => 'activities', :action => 'activity_places'
  
  #passwords controller
  map.newpassword 'passwords/create',  :controller => 'passwords', :action=>'create'
  map.newpassword 'passwords/new',  :controller => 'passwords', :action=>'new'
  map.passwords_message 'passwords/message', :controller => 'passwords', :action=>'message'
  map.passwords 'passwords',  :controller => 'passwords', :action=>'update'
  map.resources :passwords
  map.resources :users, :has_one => [:password]
  
  #profiles controller
  map.user_user_place_activities '/profile_user_place_activities', :controller=>'profiles', :action=>'user_place_activities'
  map.resources :profiles, :except => :show
  map.user "/profiles/:id", :controller => "profiles", :action => "show"

  #facebook controller
  map.fb_pull 'fb_pull', :controller=>'facebook', :action => 'fb_pull'

  #crm controller
  map.crm_admin '/crm/admin' , :controller=>'crm', :action=>'index'
  map.crm_match '/crm/match' , :controller=>'crm', :action=>'match'
  map.crm_photo '/crm/photo' , :controller=>'crm', :action=>'photo'
  map.crm_activity '/crm/activity' , :controller=>'crm', :action=>'activity'
  ActionController::Routing::Routes.draw do |map|
    map.resources :test3s
  
    map.simple_captcha '/simple_captcha/:action', :controller => 'simple_captcha'
  end
  
  map.resource :session
  map.root :controller => "sessions", :action => "new"

  # Motherload, catchall.
  map.profile "/:id", :controller => 'profiles', :action => 'show'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

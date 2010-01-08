ActionController::Routing::Routes.draw do |map|
  
  #maps controller
  map.map '/map',  :controller => 'maps', :action => 'index'
  map.big_map '/big_map' , :controller => 'maps', :action => 'map'
  
  #search controller
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
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'

  #user_messages controller
  map.inbox '/account/inbox', :controller => 'user_messages', :action => 'index'
 
  #pages controller
  map.about '/about', :controller => "pages", :action => 'about'
  map.contact '/contact', :controller => "pages", :action => 'contact'
  map.terms '/terms', :controller => "pages", :action => 'terms'

  
  #feeds controller
   map.feed '/feed', :controller => 'feeds', :action => 'feed'
  
  #place_pictures controller

  
  #user_favorites controller
  map.user_favorite_delete 'account/favorites/delete', :controller => 'user_favorites',  :action => 'destroy'
  map.user_favorite_users '/favorites/users', :controller => 'user_favorites',  :action => 'users'
  map.user_favorite_user_place_activities '/favorites/user_place_activities', :controller => 'user_favorites',  :action => 'user_place_activities'
  
  #user_activities controller
  map.user_activity_delete 'account/activities/delete', :controller => 'user_activities',  :action => 'destroy'

  #user_place_activities controller
  map.user_place_activity '/user_place_activities', :controller => "user_place_activities", :action =>"show"
  map.delete_place_activity '/user_place_activities/delete', :controller => 'user_place_activities', :action => 'destroy'
  map.favourite_place_activities 'user_place_activities/list', :controller => 'user_place_activities', :action=>'list'
  map.add_user_place_activity 'user_place_activities/add', :controller => 'user_place_activities', :action=>'create'
  map.update_user_place_activity 'user_place_activities/update', :controller => 'user_place_activities', :action=>'update'
   map.update_user_place_activity 'user_place_activities/edit', :controller => 'user_place_activities', :action=>'edit'
  #place_activities controller
  map.resources :place_activities
  map.place_activity_users '/place_activity/users', :controller => 'place_activities', :action => 'users'
  map.place_activity_user_place_activities '/place_activity/user_place_activities', :controller => 'place_activities', :action => 'user_place_activities'
  
  #places_controller
  map.resources :places, :collection => { :autocomplete => :get } do |p|
    p.resources :pictures, :controller => "place_pictures"
  end
  map.place_users '/place/users', :controller => 'places', :action => 'users'
  map.place_user_place_activities '/place/user_place_activities', :controller => 'places', :action => 'user_place_activities'
  
  #activity_controller
  map.resources :activities, :collection => { :autocomplete => :get } do |a|
    a.resources :pictures, :controller => "activity_pictures"
  end
  map.activity_users '/activity/users', :controller => 'activities', :action => 'users'
  map.activity_user_place_activities '/activity/user_place_activities', :controller => 'activities', :action => 'user_place_activities'
  
  
  #profiles controller
  map.user_user_place_activities '/users/user_place_activities', :controller=>'profiles', :action=>'user_place_activities'
  map.resources :profiles, :except => :show
  map.user "/profiles/:id", :controller => "profiles", :action => "show"
  
  map.resource :session
  map.root :controller => "sessions", :action => "new"

  # Motherload, catchall.
  map.profile "/:id", :controller => 'profiles', :action => 'show'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

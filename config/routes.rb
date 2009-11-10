ActionController::Routing::Routes.draw do |map|
  map.map '/map',  :controller => 'maps', :action => 'index'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.signup '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.inbox '/account/inbox', :controller => 'user_messages', :action => 'index'
  map.redeem  '/redeem', :controller => "users", :action => 'redeem'
  map.search '/search', :controller => "search", :action => 'index'
  map.search_criteria '/search_criteria',  :controller => "search", :action => 'search_criteria'
  map.about '/about', :controller => "pages", :action => 'about'
  map.contact '/contact', :controller => "pages", :action => 'contact'
  map.terms '/terms', :controller => "pages", :action => 'terms'
  map.update '/update', :controller => "users", :action => 'update'
  map.search_places '/search/places', :controller => 'search', :action => "places"
  map.search_people '/search/people', :controller => 'search', :action => "people"
   map.search_people '/search/people_list', :controller => 'search', :action => "people_list"
  map.search_activities '/search/activities', :controller => "search", :action => "activities"
  map.search_place_activities '/search/place_activities', :controller => "search", :action => "place_activities"
  map.activity_list '/search/activity_list', :controller => 'search', :action => "activity_list" #todo - url doesnt look good
  
  map.user_activity_list '/account/user_place_activities', :controller =>'users', :action => "user_places"
  map.resources :places, :collection => { :autocomplete => :get } do |p|
    p.resources :pictures, :controller => "place_pictures"
  end
  #todo what the hell does the below line mean
  map.resources :activities, :collection => { :autocomplete => :get } do |a|
    a.resources :pictures, :controller => "activity_pictures"
  end

  map.user_favorite_delete 'account/favorites/delete', :controller => 'user_favorites',  :action => 'destroy'
  map.user_activity_delete 'account/activities/delete', :controller => 'user_activities',  :action => 'destroy'

  map.resource :account, :controller => "users" do |u|
    u.resources :favorites, :controller => "user_favorites"
    u.resources :pictures, :controller => "user_pictures"
    u.resources :messages, :controller => "user_messages"
    u.resources :invitations, :controller => "user_invitations"
    u.resources :matches, :controller => "user_matches", :collection => { :all => :get }
    u.resources :activities, :controller => "user_activities"
    u.resources :places, :controller => "user_places"
    u.resources :place_activities, :controller => "user_place_activities"
  end
  
  map.resources :profiles, :except => :show
  map.user "/profiles/:id", :controller => "profiles", :action => "show"
  map.resource :session
  map.root :controller => "sessions", :action => "new"

  # Motherload, catchall.
  map.profile "/:id", :controller => 'profiles', :action => 'show'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

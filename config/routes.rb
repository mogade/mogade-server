Mogade::Application.routes.draw do  
  namespace 'api' do
    namespace 'gamma' do
      resources :scores, :only => [:index, :create]
      resources :achievements, :only => [:index, :create]
      resources :ranks, :only => [:index]
      resources :stats, :only => [:create]
      resources :errors, :only => [:create]
    end
  
    #v1 crap
    match '/scores' => 'legacy::Scores#get_scores', :via => :post
    match '/scores' => 'legacy::Scores#save_score', :via => :put
    match '/scores/yesterdays_rank' => 'legacy::Scores#yesterdays_rank', :via => :post
    match '/scores/yesterdays_leaders' => 'legacy::Scores#yesterdays_leaders', :via => :post
    match '/analytics/start' => 'legacy::Logs#log_start', :via => :put
    match '/achievements' => 'legacy::Achievements#create', :via => :put
    match '/conf/version' => 'legacy::Configurations#version', :via => :post
    match '/conf' => 'legacy::Configurations#get_game_configuration', :via => :post
    match '/conf/my' => 'legacy::Configurations#get_player_configuration', :via => :post
    match '/logging/error' => 'legacy::Logs#log_error', :via => :put    
  end
  
  namespace 'manage' do
    match '/accounts/:action/(:key)', :controller => 'accounts'
    match '/sessions/logout' => 'sessions#logout'
    match '/stats/data' => 'stats#data'
    match '/errors/list' => 'errors#list'
    match '/scores/count' => 'scores#count'
    match '/profiles/images' => 'profiles#images'
    match '/profiles/upload' => 'profiles#upload'

    resources :accounts, :only => [:new, :create]
    resources :sessions, :only => [:new, :create]
    resources :games, :only => [:index, :create, :show, :destroy, :update]
    resources :leaderboards, :only => [:index, :create, :destroy, :update]
    resources :achievements, :only => [:index, :create, :destroy, :update]
    resources :stats, :only => [:index]
    resources :errors, :only => [:index, :destroy]
    resources :scores, :only => [:index, :destroy]
    resources :profiles, :only => [:index, :create, :destroy]
    
    match '/:action', :controller => 'manage'
  end
  match '/manage/:controller(/:action(/:id))', :controller => /manage\/[^\/]+/
  root :to => 'home#index'
end

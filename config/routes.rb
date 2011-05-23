Mogade::Application.routes.draw do  
  namespace 'api' do
    namespace 'gamma' do
      resources :scores, :only => [:index, :create]
      resources :achievements, :only => [:index, :create]
      resources :ranks, :only => [:index]
      resources :stats, :only => [:create]
    end
  
    #v1 crap
    match '/scores' => 'legacy#save_score', :via => :put
    match '/scores/yesterdays_rank' => 'legacy#yesterdays_rank', :via => :post
    match '/scores/yesterdays_leaders' => 'legacy#yesterdays_leaders', :via => :post
    match '/conf/version' => 'legacy#version', :via => :post
    match '/conf/my' => 'legacy#player_configuration', :via => :post
    match '/conf' => 'legacy#game_configuration', :via => :post
    match '/logging/error' => 'legacy#log_error', :via => :put
    match '/analytics/start' => 'legacy#log_start', :via => :put
  end
  
  namespace 'manage' do
    match '/accounts/:action/(:key)', :controller => 'accounts'
    match '/sessions/logout' => 'sessions#logout'
    match '/stats/data' => 'stats#data'
    match '/scores/count' => 'scores#count'

    resources :accounts, :only => [:new, :create]
    resources :sessions, :only => [:new, :create]
    resources :games, :only => [:index, :create, :show, :destroy, :update]
    resources :leaderboards, :only => [:index, :create, :destroy, :update]
    resources :achievements, :only => [:index, :create, :destroy, :update]
    resources :stats, :only => [:index]
    resources :scores, :only => [:index, :destroy]
      
    match '/:action', :controller => 'manage'
  end
  match '/manage/:controller(/:action(/:id))', :controller => /manage\/[^\/]+/
  root :to => 'home#index'
end

Mogade::Application.routes.draw do  
  namespace 'api' do
    resources :scores, :only => [:index, :create]
    resources :ranks, :only => [:index]
    resources :stats, :only => [:create]
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
    resources :stats, :only => [:index]
    resources :scores, :only => [:index, :destroy]
      
    match '/:action', :controller => 'manage'
  end
  match '/manage/:controller(/:action(/:id))', :controller => /manage\/[^\/]+/
  root :to => 'home#index'
end

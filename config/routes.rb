Mogade::Application.routes.draw do  
  namespace 'api' do
    resources :scores, :only => [:index, :create]
    resources :ranks, :only => [:index]
    resources :stats, :only => [:create]
  end
  
  namespace 'manage' do
    match '/accounts/:action/(:key)', :controller => 'accounts'
    resources :accounts, :only => [:new, :create]
    
    match '/session/logout' => 'sessions#logout'
    resources :sessions, :only => [:new, :create]
    
    resources :games, :only => [:index]
      
    match '/:action', :controller => 'manage'
  end
  match '/manage/:controller(/:action(/:id))', :controller => /manage\/[^\/]+/
  root :to => 'manage::Manage#index'
end

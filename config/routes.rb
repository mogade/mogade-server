Mogade::Application.routes.draw do  
  namespace 'api' do
    resources :scores, :only => [:index, :create]
    resources :ranks, :only => [:index]
    resources :stats, :only => [:create]
  end
  
  namespace 'manage' do
    match '/account/:action/(:key)', :controller => 'accounts'
    resource :account, :only => [:new, :create]
    
    match '/session/logout' => 'sessions#logout'
    resource :session, :only => [:new, :create]
    
    match '/:action', :controller => 'manage'
  end
  match '/manage/:controller(/:action(/:id))', :controller => /manage\/[^\/]+/
  root :to => 'manage::Manage#index'
end

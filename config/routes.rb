Mogade::Application.routes.draw do  
  namespace 'api' do
    resources :scores, :only => [:index, :create]
    resources :ranks, :only => [:index]
    resources :stats, :only => [:create]
  end
  
  namespace 'manage' do
    match '/account/activate/:key' => 'accounts#activate'
    resource :account, :only => [:new, :create]
    
    match '/session/logout' => 'sessions#logout'
    resource :session, :only => [:new, :create]
    
    match '/tos' => 'manage#tos'
  end
  
  
  match '/:controller(/:action(/:id))'
  root :to => 'home#index'
end

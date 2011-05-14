Mogade::Application.routes.draw do  
  namespace 'api' do
    resources :scores, :only => [:index, :create]
    resources :ranks, :only => [:index]
    resources :stats, :only => [:create]
  end
  
  namespace 'manage' do
    match '/signups/activate/:key' => 'signups#activate'
    resource :signups, :only => [:new, :create]
  end
  
  
  match '/:controller(/:action(/:id))'
  root :to => 'home#index'
end

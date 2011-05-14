Mogade::Application.routes.draw do  
  namespace 'api' do
    resources :scores, :only => [:index, :create]
    resources :ranks, :only => [:index]
    resources :stats, :only => [:create]
  end
  
  namespace 'manage' do
    resource :signup, :only => [:index, :new]
  end
  
  
  match '/:controller(/:action(/:id))'
  root :to => 'home#index'
end

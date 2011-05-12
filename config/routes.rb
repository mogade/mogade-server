Mogade::Application.routes.draw do  
  namespace 'api' do
    resources :scores, :only => [:index, :create]
    resources :ranks, :only => [:index]
    resources :stats, :only => [:create]
  end
  
  match '/:controller(/:action(/:id))'
  root :to => 'home#index'
end

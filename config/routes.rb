Mogade::Application.routes.draw do  
  namespace 'api' do
    resources :scores, :only => [:index, :create]
    resources :ranks, :only => [:index]
  end
  
  match '/:controller(/:action(/:id))'
  root :to => 'home#index'
end

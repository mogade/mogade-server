Mogade::Application.routes.draw do  
  namespace 'api' do

  end
  
  match '/:controller(/:action(/:id))'
  root :to => 'home#index'
end

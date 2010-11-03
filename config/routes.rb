SayWhat::Application.routes.draw do
  
  devise_for :users do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
  end
  
  resources :groups do
    
    collection do
      get :request_group
      post :create_request
      get :pending_request
    end
    
  end

  root :to => "groups#request_group"
end

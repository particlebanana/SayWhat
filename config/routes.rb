SayWhat::Application.routes.draw do
  
  devise_for :users do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
  end
  
  resources :groups do
    
    collection do
      get :request_group
      get :pending_request
      get :pending_groups
    end
    
    member do
      get :pending_group
      put :approve_group
    end
    
  end

  root :to => "groups#request_group"
end

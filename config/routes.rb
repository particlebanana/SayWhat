SayWhat::Application.routes.draw do
  
  devise_for :users do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
  end
  
  match "/setup" => "groups#setup"
  match "/setup/password" => "users#setup_password", :via => "get"
  match '/setup/permalink' => "groups#setup_permalink", :via => "get"
  
  resources :users do
    
    member do
      get :setup_password
      put :create_password
    end
    
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
      get :setup
      get :setup_permalink
      put :set_permalink
    end
    
  end

  root :to => "groups#request_group"
end

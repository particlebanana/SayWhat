SayWhat::Application.routes.draw do
  
  devise_for :users do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
  end
    
  match "/settings/profile" => "users#edit", :via => "get"
  match "/settings/password" => "users#edit_password", :via => "get"
  
  match "/setup" => "groups#setup"
  match "/setup/sponsor" => "users#setup_sponsor", :via => "get"
  match '/setup/permalink' => "groups#setup_permalink", :via => "get"
  
  resources :users do
    
    member do
      get :setup_sponsor
      put :create_sponsor
      get :delete_avatar
      put :update_password
    end
    
  end
  
  resources :groups do
    
    collection do
      get :request_group
      get :pending_request
      get :pending_groups
      get :membership_request_submitted
    end
    
    member do
      get :pending_group
      put :approve_group
      get :setup
      get :setup_permalink
      put :set_permalink
      get :request_membership
      post :create_membership_request
    end
    
  end
  
  # Keep Group permalink routes at the bottom so other routes can override it
  match "/:permalink" => "groups#show"
  match "/:permalink/join" => "groups#request_membership"
  match "/:permalink/request_submitted" => "groups#membership_request_submitted"

  root :to => "groups#request_group"
end

SayWhat::Application.routes.draw do
  
  devise_for :users do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
  end
    
  match "/settings/profile" => "users#edit", :via => "get"
  match "/settings/password" => "users#edit_password", :via => "get"
  
  # Group Setup Steps
  match "/setup" => "groups#setup"
  match "/setup/sponsor" => "users#setup_sponsor", :via => "get"
  match '/setup/permalink' => "groups#setup_permalink", :via => "get"
  
  # Member Setup
  match "/setup/member" => "users#setup_member", :via => "get"
  
  resources :users do
    
    member do
      get :setup_sponsor
      put :create_sponsor
      get :delete_avatar
      put :update_password
      get :approve_pending_membership
      get :setup_member
      put :create_member
    end
    
  end
  
  # Groups
  match "/groups" => "groups#index", :via => "get"
  match "/groups" => "groups#create", :via => "post"
  match "/groups/new" => "groups#new", :via => "get"
  
  match "/groups/pending" => "groups#pending_request", :via => "get"
  match "/groups/pending_groups" => "groups#pending_groups", :via => "get"
  
  match "/groups/:permalink/edit" => "groups#edit", :via => "get"
  match "/groups/:permalink" => "groups#show", :via => "get"
  match "/groups/:permalink" => "groups#update", :via => "put"
  match "/groups/:permalink" => "groups#destroy", :via => "delete"
  
  # Groups - Create/Setup a group
  match "/groups/:group_id/pending_group" => "groups#pending_group", :via => "get"
  match "/groups/:group_id/approve_group" => "groups#approve_group", :via => "put"
  match "/groups/:group_id/setup" => "groups#setup", :via => "get"
  match "/groups/:group_id/setup_permalink" => "groups#setup_permalink", :via => "get"
  match "/groups/:group_id/set_permalink" => "groups#set_permalink", :via => "put"

  # Groups - Member requests
  match "/groups/:permalink/join" => "groups#request_membership", :via => "get"
  match "/groups/:permalink/create_membership_request" => "groups#create_membership_request", :via => "post"
  match "/groups/:permalink/invite" => "groups#create_invite", :via => "get"
  match "/groups/:permalink/send_invite" => "groups#send_invite", :via => "post"
  match "/groups/:permalink/request_submitted" => "groups#membership_request_submitted", :via => "get"
  match "/groups/:permalink/pending_memberships" => "groups#pending_membership_requests", :via => "get"            


  # Projects - CRUD
  match "/groups/:permalink/projects" => "projects#index", :via => "get"
  match "/groups/:permalink/projects" => "projects#create", :via => "post"
  match "/groups/:permalink/projects/new" => "projects#new", :via => "get"
  match "/groups/:permalink/projects/:name/edit" => "projects#edit", :via => "get"
  match "/groups/:permalink/projects/:name" => "projects#show", :via => "get"
  match "/groups/:permalink/projects/:name" => "projects#update", :via => "put"
  match "/groups/:permalink/projects/:name" => "projects#destroy", :via => "delete"
  

  root :to => "groups#request_group"
end

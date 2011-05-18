require 'minigrant/MiniGrant.rb' if THEME['minigrant_app']
require 'resources/Resources.rb' if THEME['static_resources']

SayWhat::Application.routes.draw do
  
  # Mount Mini-Grant application & Static Resources
  authenticate :user do
    match "/grants" => MiniGrant::Main, :anchor => false if THEME['minigrant_app']
    match "/resources" => StaticResources::Main, :anchor => false if THEME['static_resources']
  end
  
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
      get :deny_pending_membership
      get :setup_member
      put :create_member
    end
    
  end
  
  # Admin Panel
  match "/admin"                =>  redirect('/admin/dashboard')
  match "/admin/dashboard"      =>  "admin#index",                  :via => "get"
  match "/admin/requests"       =>  "admin#show_requests",          :via => "get"
  match "/admin/requests/:id"   =>  "admin#view_request",           :via => "get"
  
  match "/admin/denied_group_reasons" =>  "admin#denied_group_reasons",   :via => "get"
  match "/admin/denied_grant_reasons" =>  "admin#denied_grant_reasons",   :via => "get"
  
  match "/admin/grants"         =>  "admin#show_grants",            :via => "get"
  match "/admin/grants/pending" =>  "admin#show_pending_grants",    :via => "get"
  match "/admin/grants/:id"     =>  "admin#view_grant",             :via => "get"
  match "/admin/grants/:id"     =>  "admin#approve_grant",          :via => "put"
  match "/admin/grants/:id"     =>  "admin#deny_grant",             :via => "post"
  
  match "/admin/groups"         =>  "admin#show_groups",            :via => "get"
  match "/admin/groups/:id"     =>  "admin#view_group",             :via => "get"
  match "/admin/groups/:id"     =>  "admin#update_group",           :via => "put"
  
  match "/admin/groups/:id/choose_sponsor"    =>  "admin#choose_sponsor",       :via => "get"
  match "/admin/groups/:id/reassign_sponsor"  =>  "admin#reassign_sponsor",     :via => "put"
  
  # Messaging
  match "/messages" => "messages#index", :via => "get"
  match "/messages" => "messages#create", :via => "post"
  match "/messages/new" => "messages#new", :via => "get"
  match "/messages/:id" => "messages#show", :via => "get"
  match "/messages/:id" => "messages#destroy", :via => "delete"
  
  # Groups
  match "/groups" => "groups#index", :via => "get"
  match "/groups" => "groups#create", :via => "post"
  match "/groups/new" => "groups#request_group", :via => "get"
  
  match "/groups/pending" => "groups#pending_request", :via => "get"
  match "/groups/pending_groups" => "groups#pending_groups", :via => "get"
  
  
  # Groups - Create/Setup a group (no permalink created yet)
  match "/groups/:group_id/approve_group"     => "groups#approve_group",    :via => "put"
  match "/groups/:group_id/deny_group"        => "groups#deny_group",       :via => "post"
  
  match "/groups/:group_id/setup"             => "groups#setup",            :via => "get"
  match "/groups/:group_id/setup_permalink"   => "groups#setup_permalink",  :via => "get"
  match "/groups/:group_id/set_permalink"     => "groups#set_permalink",    :via => "put"
  
  
  match "/groups/:permalink/edit" => "groups#edit", :via => "get"
  match "/groups/:permalink/delete_photo" => "groups#delete_photo", :via => "get"
  match "/groups/:permalink" => "groups#show", :via => "get"
  match "/groups/:permalink" => "groups#update", :via => "put"
  match "/groups/:permalink" => "groups#destroy", :via => "delete"
  
  
  # Groups - Member requests
  match "/groups/:permalink/join" => "groups#request_membership", :via => "get"
  match "/groups/:permalink/create_membership_request" => "groups#create_membership_request", :via => "post"
  match "/groups/:permalink/invite" => "groups#create_invite", :via => "get"
  match "/groups/:permalink/send_invite" => "groups#send_invite", :via => "post"
  match "/groups/:permalink/request_submitted" => "groups#membership_request_submitted", :via => "get"
  match "/groups/:permalink/pending_memberships" => "groups#pending_membership_requests", :via => "get"       
  
  
  # Users - Assign Sponsors to Group
  match "/groups/:permalink/edit/choose_youth_sponsor" => "users#choose_youth_sponsor", :via => "get"
  match "/groups/:permalink/edit/assign_youth_sponsor/:user_id" => "users#assign_youth_sponsor", :via => "put"
  match "/groups/:permalink/edit/revoke_youth_sponsor/:user_id" => "users#revoke_youth_sponsor", :via => "put"
  
  
  # Projects
  match "/projects" => "projects#all", :via => "get"
  match "/projects/filter" => "projects#filter", :via => "get"
  
  
  # Projects - CRUD
  match "/groups/:permalink/projects" => "projects#index", :via => "get"
  match "/groups/:permalink/projects" => "projects#create", :via => "post"
  match "/groups/:permalink/projects/new" => "projects#new", :via => "get"
  match "/groups/:permalink/projects/:name/edit" => "projects#edit", :via => "get"
  match "/groups/:permalink/projects/:name/delete_photo" => "projects#delete_photo", :via => "get"
  match "/groups/:permalink/projects/:name" => "projects#show", :via => "get"
  match "/groups/:permalink/projects/:name" => "projects#update", :via => "put"
  match "/groups/:permalink/projects/:name" => "projects#destroy", :via => "delete"
  
  
  # Project Comments - CRUD
  match "/groups/:permalink/projects/:name/comments" => "comments#create", :via => "post"
  match "/groups/:permalink/projects/:name/comments/:comment_id/edit" => "comments#edit", :via => "get"
  match "/groups/:permalink/projects/:name/comments/:comment_id" => "comments#update", :via => "put"
  match "/groups/:permalink/projects/:name/comments/:comment_id" => "comments#destroy", :via => "delete"
  
  # Project Reporting
  match "/groups/:permalink/projects/:name/report/new" => "reports#new", :via => "get"
  match "/groups/:permalink/projects/:name/report" => "reports#create", :via => "post"
  
  
  root :to => "groups#home"
end

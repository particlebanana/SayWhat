require 'minigrant/MiniGrant.rb' if CONFIG['minigrant_app']
require 'resources/Resources.rb' if CONFIG['static_resources']

SayWhat::Application.routes.draw do
  
  # Mount Mini-Grant application & Static Resources
  authenticate :user do
    match "/grants" => MiniGrant::Main, :anchor => false if CONFIG['minigrant_app']
    match "/resources" => StaticResources::Main, :anchor => false if CONFIG['static_resources']
  end
  
  devise_for :users do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
  end
    
  match "/settings/profile" => "users#edit", :via => "get"
  match "/settings/password" => "users#edit_password", :via => "get"
    
  resources :users
    
  # Pages
  match "/join"                 => "pages#join",                    :via => "get"
  match "/admin"                =>  redirect('/admin/dashboard')
  match "/admin/dashboard"      =>  "pages#index",                  :via => "get"
  
  # Admin Group Requests Controller
  match "/admin/group_requests"               =>  "admin_group_requests#index",      :via => "get"
  match "/admin/group_requests/:id"           =>  "admin_group_requests#show",       :via => "get"
  match "/admin/group_requests/:id"           =>  "admin_group_requests#update",     :via => "put"
  match "/admin/group_requests/:id/deny"      =>  "admin_group_requests#destroy",    :via => "get"
  
  # Admin Groups Controller
  match "/admin/groups"                   =>  "admin_groups#index",              :via => "get"
  match "/admin/groups/:id"               =>  "admin_groups#show",               :via => "get"
  match "/admin/groups/:id"               =>  "admin_groups#update",             :via => "put"
  match "/admin/groups/:id"               =>  "admin_groups#destroy",            :via => "delete"
  
  # Admin Sponsors Controller
  match "/admin/groups/:id/sponsors"      =>  "admin_sponsors#index",            :via => "get"
  match "/admin/groups/:id/sponsors"      =>  "admin_sponsors#update",           :via => "put"
  
  # Admin Grant Requests Controller
  match "/admin/grants/pending"           =>  "admin_grant_requests#index",      :via => "get"
  match "/admin/grants/:id/edit"          =>  "admin_grant_requests#edit",       :via => "get"
  match "/admin/grants/:id"               =>  "admin_grant_requests#update",     :via => "put"
  match "/admin/grants/:id/deny"          =>  "admin_grant_requests#destroy",    :via => "get"
  
  # Admin Grants Controller
  match "/admin/grants"                   =>  "admin_grants#index",              :via => "get"
  match "/admin/grants/:id"               =>  "admin_grants#show",               :via => "get"
  match "/admin/grants/:id"               =>  "admin_grants#destroy",            :via => "delete"
  
  # Admin Users Controller
  match "/admin/users"                    =>  "admin_users#index",               :via => "get"
  match "/admin/users/:id"                =>  "admin_users#edit",                :via => "get"
  match "/admin/users/:id"                =>  "admin_users#update",              :via => "put"
  match "/admin/users/:id"                =>  "admin_users#destroy",             :via => "delete"
  match "/admin/users/:id/remove_avatar"  =>  "admin_users#remove_avatar",        :via => "delete"
  
  # Messaging
  match "/messages"             => "messages#index",       :via => "get"
  match "/messages"             => "messages#create",      :via => "post"
  match "/messages/new"         => "messages#new",         :via => "get"
  match "/messages/:id"         => "messages#show",        :via => "get"
  match "/messages/:id"         => "messages#destroy",     :via => "delete"
    
  # Groups
  resources :groups do
    resource :memberships
    resources :projects do
      resources :comments
    end
  end
  
  # Youth Sponsors
  match "/groups/youth_sponsors"   => "youth_sponsors#index",       :via => "get"
  match "/groups/youth_sponsors"   => "youth_sponsors#update",      :via => "put"
  match "/groups/youth_sponsors"   => "youth_sponsors#destroy",     :via => "delete"
  
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
  
  
  root :to => "pages#home"
end

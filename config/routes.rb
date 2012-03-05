SayWhat::Application.routes.draw do
  
  # Mount Mini-Grant application & Static Resources
  authenticate :user do
    match "/grants" => MiniGrant::Main, :anchor => false if CONFIG['minigrant_app']
    match "/resources" => StaticResources::Main, :anchor => false if CONFIG['static_resources']
  end
  
  devise_for :users do
    get "/sign_up" => "devise/registrations#new"
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
  end

  match "/settings" => "users#edit", :via => "get"
  match "/notifications" => "notifications#index", :via => "get"
    
  resources :users
    
  # Pages
  match "/join"                 => "pages#join",                    :via => "get"
  match "/history"              => "pages#history",                 :via => "get"
  match "/leon"                 => "pages#leon",                    :via => "get"
  match "/ttfkd"                => "pages#ttfkd",                   :via => "get"
  match "/TTFKD"                => "pages#ttfkd",                   :via => "get"
  match "/admin"                =>  redirect('/admin/dashboard')
  match "/admin/dashboard"      =>  "pages#index",                  :via => "get"

  # Project Photo Gallery "edit mode"
  match "/groups/:group_id/projects/:project_id/photos/edit" => "photos#edit",  :via => "get"
  
  # Admin Group Requests Controller
  match "/admin/group_requests"               =>  "admin_group_requests#index",      :via => "get"
  match "/admin/group_requests/:id"           =>  "admin_group_requests#show",       :via => "get"
  match "/admin/group_requests/:id"           =>  "admin_group_requests#update",     :via => "put"
  
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
  
  # Admin Grants Controller
  match "/admin/grants"                   =>  "admin_grants#index",              :via => "get"
  match "/admin/grants/:id"               =>  "admin_grants#show",               :via => "get"
  match "/admin/grants/:id"               =>  "admin_grants#destroy",            :via => "delete"
  
  # Admin Users Controller
  match "/admin/users"                    =>  "admin_users#index",               :via => "get"
  match "/admin/users/:id"                =>  "admin_users#edit",                :via => "get"
  match "/admin/users/:id"                =>  "admin_users#update",              :via => "put"
  match "/admin/users/:id"                =>  "admin_users#destroy",             :via => "delete"
  match "/admin/users/:id/remove_avatar"  =>  "admin_users#remove_avatar",       :via => "delete"
    
  # Groups
  resources :groups do
    resources :comments do
      resources :comments
    end
    resources :memberships
    resources :projects do
      resources :grants
      resources :photos
      resources :reports
      resources :comments do
        resources :comments
      end
    end
  end

  # Projects Overview
  match "/projects"   =>    "projects#overview",      :via => "get"
  
  # Youth Sponsors
  match "/groups/youth_sponsors"   => "youth_sponsors#index",       :via => "get"
  match "/groups/youth_sponsors"   => "youth_sponsors#update",      :via => "put"
  match "/groups/youth_sponsors"   => "youth_sponsors#destroy",     :via => "delete"
  
  root :to => "pages#home"
end

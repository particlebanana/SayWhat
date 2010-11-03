SayWhat::Application.routes.draw do
  
  devise_for :users do
    get "/login" => "devise/sessions#new"
  end
  
  resources :groups do
    
    member do
      get :request
      post :create_request
    end
    
  end

  root :to => "groups#request"
end

OrangePeel::Application.routes.draw do
  
  devise_for :users do
    get "/login" => "devise/sessions#new"
  end

  #root :to => "welcome#index"
end

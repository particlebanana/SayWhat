require 'sinatra/base'
require 'haml'
require 'sass'

module StaticResources
  
  class AppBase < Sinatra::Base
    set :static, true
    set :public, 'public/'
    
    set :views, File.dirname(__FILE__) + '/templates/main'    
  end
  
  class Main < AppBase
    
    get "/" do
      redirect '/resources/downloads'
    end
    
    get "/downloads" do
      haml :downloads
    end
    
    get "/links" do
      haml :links
    end
    
  end
    
end
  
  

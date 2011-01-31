require 'sinatra/base'
require 'haml'
require 'sass'
require 'mongoid'
require 'pony'

module MiniGrant
  
  class AppBase < Sinatra::Base
    set :static, true
    set :public, 'public/'
    
    set :views, File.dirname(__FILE__) + '/templates/main'    
  end
  
  class Main < AppBase
    
    get "/" do
      haml :index
    end
    
    get "/apply" do
      @grant_app = Grant.new()
      haml :application
    end
    
    post "/apply" do
      @grant_app = Grant.new(params['application'])
      if @grant_app.save
        Pony.mail :to => params['application']['adult_email'],
                  :from => "admin@txsaywhat.com",
                  :subject => "SayWhat! Mini-Grant Information",
                  :body => erb(:approved_email),
                  :via => :smtp,
                  :smtp => {
                    :port   => '25',
                    :user_name  => ENV['SENDGRID_USERNAME'],
                    :password   => ENV['SENDGRID_PASSWORD'],
                    :address   => 'smtp.sendgrid.net',
                    :authentication   => :plain,
                    :domain => ENV['SENDGRID_DOMAIN']
                  }
                  
        Pony.main :to => "info@txsaywhat.com",
                  :from => "admin@txsaywhat.com",
                  :subject => "SayWhat! Mini-Grant Application",
                  :body => erb(:application_email),
                  :via => :smtp,
                  :smtp => {
                    :port   => '25',
                    :user_name  => ENV['SENDGRID_USERNAME'],
                    :password   => ENV['SENDGRID_PASSWORD'],
                    :address   => 'smtp.sendgrid.net',
                    :authentication   => :plain,
                    :domain => ENV['SENDGRID_DOMAIN']
                  }
                            
        redirect '/grants/completed'
      else
        haml :application
      end 
    end
    
    get "/completed" do
      haml :completed
    end
    
  end
    
end
  
  

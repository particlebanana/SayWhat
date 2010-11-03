class ApplicationController < ActionController::Base
  protect_from_forgery
  
  class ApplicationController < ActionController::Base
    rescue_from CanCan::AccessDenied do |exception|
      flash[:alert] = exception.message
      redirect_to root_url
    end
  end
  
end

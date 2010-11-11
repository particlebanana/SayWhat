class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end
  
  def after_sign_in_path_for(resource)
    if resource.is_a?(User) && resource.status == "active" && resource.role == "adult sponsor"
      '/' + resource.group.permalink
    else
      super
    end
  end
            
end

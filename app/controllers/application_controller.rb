class ApplicationController < ActionController::Base
    before_action :authenticate_user!, unless: :public_controller?
  
    protected
  
    def after_sign_in_path_for(resource)
      welcome_path
    end
  
    private
  
    def public_controller?
      controller_name == "home" || devise_controller?
    end
  end
  

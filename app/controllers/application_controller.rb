class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @current_user = 'username_place_holder'
  end
end

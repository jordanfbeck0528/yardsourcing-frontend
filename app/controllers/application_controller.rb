class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def set_purposes
    info = EngineService.all_purposes
    @purposes = info[:data].map do |obj_info|
      OpenStruct.new({ id: obj_info[:id],
                       name: obj_info[:attributes][:name].titleize})
    end 
  end
end

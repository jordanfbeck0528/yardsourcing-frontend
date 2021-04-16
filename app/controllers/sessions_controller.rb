class SessionsController < ApplicationController
  def create
    # @user = User.find_or_create_from_auth_hash(auth_hash)
    user = User.from_omniauth(request.env['omniauth.auth'])

    session[:user_id] = user.id
    flash[:success] = "Welcome, #{user.username}"
    redirect_to host_dashboard_index_path
  end

  def bad
    flash[:error] = "Sorry, your credentials are bad."
    redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end

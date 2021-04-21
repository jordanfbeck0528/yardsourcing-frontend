class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(request.env['omniauth.auth'])

    session[:user_id] = user.id
    flash[:success] = "Welcome, #{user.username}"
    redirect_to renter_dashboard_index_path
  end

  def bad
    flash[:error] = "Sorry, your credentials are bad."
    redirect_to root_path
  end
end

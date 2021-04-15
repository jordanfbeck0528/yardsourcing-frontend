class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(request.env['omniauth.auth'])
    if user.valid?
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.username}"
      redirect_to host_dashboard_index_path
    else
      flash[:error] = "Sorry, your credentials are bad."
      redirect_to root_path
    end
  end

  def bad
    flash[:error] = "Sorry, your credentials are bad."
    redirect_to root_path
  end
end

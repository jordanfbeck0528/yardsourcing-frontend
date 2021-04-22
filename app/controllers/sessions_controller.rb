class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(request.env['omniauth.auth'])

    session[:user_id] = user.id
    redirect_to renter_dashboard_index_path
  end

  def destroy
    session.delete :user_id
    flash[:message] = 'You have been logged out.'
    redirect_to root_path
  end

  def bad
    flash[:error] = "Sorry, your credentials are bad."
    redirect_to root_path
  end
end

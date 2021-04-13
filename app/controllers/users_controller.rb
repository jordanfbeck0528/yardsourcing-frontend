class UsersController < ApplicationController

  def login
    user = User.find_by(email: params[:email].downcase)
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.username}"
      redirect_to user_path(user.id)
    else
      flash[:error] = "Sorry, your credentials are bad."
      render :root_path
    end
  end

  def show
  end

end

class UsersController < ApplicationController

  def login
     user = User.find_by(email: params[:email].downcase)
    if user != nil && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.username}"
      redirect_to user_path(user.id)
    else
      flash[:error] = "Sorry, your credentials are bad."
      redirect_to root_path
    end
  end

  def show
  end

  def new
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.username}!"
      redirect_to user_path(user.id)
    else
      flash.now[:error] = 'You are missing fields. Both passwords must match.'
      render :new, obj: user
    end
  end

  private

  def user_params
    params.permit(:username, :email, :password, :password_confirmation)
  end

end

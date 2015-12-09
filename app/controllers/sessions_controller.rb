class SessionsController < ApplicationController
  def create
    @user = User.find_by(name: params[:name])
    if @user.nil?
      redirect_to login_path
    elsif @user.password == params[:user_password]
      session[:user_id] = @user.id
      redirect_to @user
    else
      redirect_to login_path
    end
  end

  def destroy
    reset_session
    redirect_to root_url
  end

  # New route
  def login
  end
end

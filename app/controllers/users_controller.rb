class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
    @sort_tweets = @user.tweets.sort_by(&:created_at).reverse
  end

  # GET /users/new
  def new
    @user = User.new
    session[:user_id] = @user.id
  end

  # GET /users/1/edit
  def edit
  end

  # helper method for follow
  def add_user_follow
    @follower.following << @following.id
    @following.followers << @follower.id
    @follower.save
    if @following.save
      redirect_to @following, notice: 'Sucessfully following user.'
    else
      redirect_to @following
    end
  end

  # POST /users/1/follow
  def follow
    @follower = current_user
    @following = User.find(params[:id])
    if @follower.following.include?(@following.id)
      redirect_to @following, notice: 'Already following user.'
    elsif @follower.id == @following.id
      redirect_to @following, notice: 'Cannot follow yourself.'
    else
      add_user_follow
    end
  end

  # Helper method to make params shorter variable names (for line length)
  def shorter_var
    @p = params[:user_password]
    @e = params[:user_email]
    @n = params[:user_name]
  end

  # POST /users
  def create
    shorter_var
    @user = User.new(name: @n, password_hash: @p, email: @e, \
                     followers: [], following: [])
    @user.password = params[:user_password]
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    @user.update(name: params[:user][:name])
    @user.update(email: params[:user][:email])
    @user.password = params[:user][:password_hash]
    if @user.save
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # Removes follower when user is deleted
  def remove_follower
    @user.following.each do |follower|
      user2 = User.find(follower)
      user2.followers.delete(@user.id)
      user2.update(followers: user2.followers)
      user2.save
    end
  end

  # Removes following when user is deleted
  def remove_following
    @user.followers.each do |following|
      user2 = User.find(following)
      user2.following.delete(@user.id)
      user2.update(following: user2.following)
      user2.save
    end
  end

  # DELETE /users/1
  def destroy
    remove_follower
    remove_following
    @user.tweets.each(&:destroy)
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
    reset_session
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :password_hash)
  end
end

class WelcomeController < ApplicationController
  # Get '/'
  def index
    return unless logged_in?
    @all_tweets = []
    current_user.following.each do |follow|
      follow_user = User.find(follow)
      follow_user.tweets.each do |tweet|
        tweet.text.insert(0, "#{follow_user.name}: ")
        @all_tweets << tweet
      end
    end
    @all_tweets_sort = @all_tweets.sort_by(&:created_at).reverse
  end

  # Handles search bar functionality
  def search
    user = User.where(name: params[:name]).first
    if user
      redirect_to "/users/#{user.id}"
    else
      redirect_to '/', notice: 'User by that name does not exist.'
    end
  end
end

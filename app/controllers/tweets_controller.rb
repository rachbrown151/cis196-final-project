class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]

  # GET /tweets/1/edit
  def edit
  end

  def new
    @tweet = Tweet.new
  end

  # Helper function to make hashtags when tweet is created/edited
  def make_tags
    params[:tweet][:text].split(' ').each do |word|
      if word.start_with?('#')
        tag = Hashtag.new(tag: word, tweet: @tweet)
        tag.save
      end
    end
  end

  # POST /tweets
  def create
    @tweet = Tweet.new(text: params[:tweet][:text], user: current_user)
    if @tweet.save
      make_tags
      @tweet.hashtags.each do |hashtag|
      end
      redirect_to current_user, notice: 'Tweet was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /tweets/1
  def update
    @tweet.hashtags.each(&:destroy)
    make_tags
    @tweet.update(text: params[:tweet][:text])
    redirect_to current_user
  end

  # DELETE /tweets/1
  def destroy
    @tweet.hashtags.each(&:destroy)
    @tweet.destroy
    redirect_to current_user, notice: 'Tweet was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def tweet_params
    params.require(:tweet).permit(:text, :user_id)
  end
end

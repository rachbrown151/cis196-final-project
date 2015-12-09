class HashtagsController < ApplicationController
  before_action :set_hashtag, only: [:show]

  # GET /hashtags/1
  def show
    @hashtags = Hashtag.where(tag: params[:id])
    @hashtags = @hashtags.sort_by(&:created_at).reverse
  end

  private

  def set_hashtag
    nil
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def hashtag_params
    params.require(:hashtag).permit(:tag)
  end
end

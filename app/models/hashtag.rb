class Hashtag < ActiveRecord::Base
  validates :tag, presence: true
  validates :tag, length: { minimum: 2 }
  belongs_to :tweet
end

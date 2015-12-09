class Tweet < ActiveRecord::Base
  validates :text, presence: true
  validates :text, length: { minimum: 5 }
  belongs_to :user
  has_many :hashtags, dependent: :destroy
end

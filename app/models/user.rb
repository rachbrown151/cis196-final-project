require 'bcrypt'
class User < ActiveRecord::Base
  include BCrypt
  serialize :followers, Array
  serialize :following, Array

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, length: { minimum: 2 }
  validates :email, presence: true
  validates :password, presence: true
  has_many :tweets, dependent: :destroy

  # BCrypt password functions
  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end

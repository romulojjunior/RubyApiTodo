class User < ApplicationRecord
  validates :email, :password, :api_key, presence: true
  has_many :cards
end

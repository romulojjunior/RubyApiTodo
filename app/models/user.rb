class User < ApplicationRecord
  validates :email, :password, :api_key, presence: true
  has_many :cards
  has_many :tasks, through: :cards
  accepts_nested_attributes_for :tasks
end

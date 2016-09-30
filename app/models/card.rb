class Card < ApplicationRecord
  belongs_to :user
  has_many :tasks
  validates :name, :status, presence: true
end

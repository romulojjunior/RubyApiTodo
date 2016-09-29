class Card < ApplicationRecord
  has_many :tasks
  validates :name, :status, presence: true
end

class Card < ApplicationRecord
  belongs_to :user
  has_many :tasks
  validates :name, presence: true

  enum status: [:enabled, :hidden, :disabled]
end

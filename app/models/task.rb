class Task < ApplicationRecord
  belongs_to :card
  validates :name, presence: true
  enum status: [:todo, :doing, :paused, :pedding, :done]
end

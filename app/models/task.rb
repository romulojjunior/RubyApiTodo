class Task < ApplicationRecord
  belongs_to :card
  validates :name, :status, presence: true
end

class Ticket < ApplicationRecord
  validates :user_id, presence: true, numericality: true
  validates :title, presence: true
end

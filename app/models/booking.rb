class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :time_slot
  has_one :score, dependent: :destroy
end

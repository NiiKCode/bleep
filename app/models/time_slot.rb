class TimeSlot < ApplicationRecord
  belongs_to :scheduled_session
  has_many :bookings, dependent: :destroy
end

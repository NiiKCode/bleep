class ScheduledSession < ApplicationRecord
  belongs_to :location
  belongs_to :session_type
  has_many :time_slots, dependent: :destroy
end

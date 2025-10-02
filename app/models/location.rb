class Location < ApplicationRecord
  has_many :scheduled_sessions, dependent: :destroy
end

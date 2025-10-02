class SessionType < ApplicationRecord
  has_many :scheduled_sessions, dependent: :destroy
end

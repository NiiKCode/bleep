class ScheduledSession < ApplicationRecord
  belongs_to :location
  belongs_to :session_type

  has_many :time_slots, dependent: :destroy

  # =========================
  # SCOPES
  # =========================

  scope :upcoming, -> {
    where("date >= ?", Date.current)
  }

  scope :ordered, -> {
    order(:date)
  }

  # =========================
  # AVAILABLE DATES
  # =========================

  def self.available_dates_for_location(location_id)
    upcoming
      .where(location_id: location_id)
      .distinct
      .ordered
      .pluck(:date)
  end

  # =========================
  # FILTERED SESSIONS
  # =========================

  def self.for_location_and_date(location_id:, date:)
    upcoming
      .includes(
        :location,
        :session_type,
        time_slots: :bookings
      )
      .where(
        location_id: location_id,
        date: date
      )
      .ordered
  end
end

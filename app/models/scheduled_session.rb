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
  # FILTERS
  # =========================

  def self.available_dates_for(location_id)
    upcoming
      .where(location_id: location_id)
      .ordered
      .distinct
      .pluck(:date)
  end

  def self.available_session_types(location_id, date)
    SessionType
      .joins(:scheduled_sessions)
      .merge(
        upcoming.where(
          location_id: location_id,
          date: date
        )
      )
      .distinct
      .order(:title)
  end

  def self.filtered(location_id:, date:, session_type_id:)
    upcoming
      .includes(:location, :session_type, :time_slots)
      .where(
        location_id: location_id,
        date: date,
        session_type_id: session_type_id
      )
      .ordered
  end
end

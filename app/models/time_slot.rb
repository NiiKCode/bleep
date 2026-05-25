class TimeSlot < ApplicationRecord
  belongs_to :scheduled_session
  has_many :bookings, dependent: :destroy

  scope :upcoming, -> {
    where("start_time > ?", Time.current)
  }

  # =========================================
  # 🔒 ENFORCE CONSISTENCY
  # =========================================
  before_validation :align_with_session_date

  validates :start_time, :end_time, presence: true
  validate :end_after_start
  validate :must_match_session_date

  # =========================================
  # DOMAIN HELPERS
  # =========================================
  def upcoming?
    start_time.present? && start_time > Time.current
  end

  def past?
    end_time.present? && end_time < Time.current
  end

  private

  # 🔥 Force date alignment
  def align_with_session_date
    return unless scheduled_session&.date
    return unless start_time.present? && end_time.present?

    date = scheduled_session.date

    self.start_time = combine(date, start_time)
    self.end_time   = combine(date, end_time)
  end

  # 🔒 HARD VALIDATION (prevents bad data)
  def must_match_session_date
    return unless scheduled_session&.date
    return unless start_time && end_time

    session_date = scheduled_session.date

    if start_time.to_date != session_date || end_time.to_date != session_date
      errors.add(:base, "Time slots must match the session date")
    end
  end

  def combine(date, time)
    Time.zone.local(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.min,
      time.sec
    )
  end

  def end_after_start
    return unless start_time && end_time

    if end_time <= start_time
      errors.add(:end_time, "must be after start time")
    end
  end
end

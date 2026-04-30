class TimeSlot < ApplicationRecord
  belongs_to :scheduled_session
  has_many :bookings, dependent: :destroy

  # =========================================
  # 🔥 CRITICAL FIX: SYNC DATE + TIME
  # =========================================
  before_validation :align_with_session_date

  # =========================================
  # VALIDATIONS
  # =========================================
  validates :start_time, :end_time, presence: true
  validate :end_after_start

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

  # =========================================
  # 🔥 THIS FIXES YOUR BUG
  # =========================================
  def align_with_session_date
    return unless scheduled_session&.date
    return unless start_time.present? && end_time.present?

    session_date = scheduled_session.date

    self.start_time = combine_date_and_time(session_date, start_time)
    self.end_time   = combine_date_and_time(session_date, end_time)
  end

  def combine_date_and_time(date, time)
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

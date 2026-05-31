class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :time_slot

  belongs_to :partner_user,
             class_name: "User",
             optional: true

  # ========================
  # STATUS
  # ========================
  enum status: {
    pending: "pending",
    paid: "paid",
    cancelled: "cancelled",
    completed: "completed"
  }

  # ========================
  # DOMAIN HELPERS
  # ========================
  def scheduled_session
    time_slot&.scheduled_session
  end

  def session_type
    scheduled_session&.session_type
  end

  def price
    scheduled_session&.price
  end

  def session_date
    scheduled_session&.date
  end

  def display_location
    scheduled_session&.location&.name
  end

  # ========================
  # ✅ SINGLE SOURCE OF TRUTH (TIME-BASED, TZ SAFE)
  # ========================
  def upcoming?
    return false unless time_slot&.start_time
    time_slot.start_time > Time.current
  end

  def completed?
    return false unless time_slot&.end_time
    time_slot.end_time < Time.current
  end

  # ========================
  # VALIDATIONS
  # ========================
  validates :user_id,
  uniqueness: { scope: [:time_slot_id, :partner_user_id] }

  validates :score,
            numericality: { greater_than_or_equal_to: 0 },
            allow_nil: true

  validate :time_slot_has_capacity

  # ========================
  # SCOPES (MATCH METHODS EXACTLY)
  # ========================
  scope :with_scores, -> { where.not(score: nil) }

  scope :upcoming, -> {
    joins(:time_slot)
      .where(status: "paid")
      .where("time_slots.start_time > ?", Time.current)
      .order("time_slots.start_time ASC")
  }

  scope :completed_sessions, -> {
    joins(:time_slot)
      .where("time_slots.end_time < ?", Time.current)
      .order("time_slots.start_time DESC")
  }

  # ========================
  # DISPLAY HELPERS (OPTIONAL BUT CLEAN)
  # ========================
  def display_time_range
    return unless time_slot

    "#{time_slot.start_time.strftime("%H:%M")} - #{time_slot.end_time.strftime("%H:%M")}"
  end

  def display_date
    session_date&.strftime("%a %-d %b")
  end

  private

  def time_slot_has_capacity
    return unless time_slot

    existing_bookings = time_slot.bookings.where.not(id: id).count

    if existing_bookings >= time_slot.capacity
      errors.add(:base, "This time slot is fully booked.")
    end
  end
end

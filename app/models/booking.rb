class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :time_slot

  # ✅ Only ONE partner type now (User)
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
  # DOMAIN HELPERS (🔥 NEW)
  # ========================
  def scheduled_session
    time_slot.scheduled_session
  end

  def session_type
    scheduled_session.session_type
  end

  def price
    scheduled_session.price
  end

  def session_date
    scheduled_session.date
  end

  def completed?
    time_slot.end_time < Time.current
  end

  # ========================
  # VALIDATIONS
  # ========================
  validates :user_id,
            uniqueness: { scope: :time_slot_id }

  validates :score,
            numericality: { greater_than_or_equal_to: 0 },
            allow_nil: true

  validate :time_slot_has_capacity

  # ========================
  # SCOPES (useful for graphs)
  # ========================
  scope :with_scores, -> { where.not(score: nil) }

  private

  def time_slot_has_capacity
    return unless time_slot

    existing_bookings = time_slot.bookings.where.not(id: id).count

    if existing_bookings >= time_slot.capacity
      errors.add(:base, "This time slot is fully booked.")
    end
  end
end

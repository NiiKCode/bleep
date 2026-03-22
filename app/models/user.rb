class User < ApplicationRecord
  # Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ========================
  # BOOKINGS
  # ========================
  has_many :bookings, dependent: :destroy
  has_many :time_slots, through: :bookings

  # ========================
  # FRIENDSHIPS (SELF-JOIN)
  # ========================
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships, source: :friend

  # Optional (for reverse lookups - useful later)
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  # ========================
  # HELPERS
  # ========================
  def initials
    first = first_name.to_s.first
    last = last_name.to_s.first
    "#{first}#{last}".upcase.presence || "U"
  end

  # ========================
  # OPTIONAL: ALL FRIENDS (SAFE)
  # ========================
  def all_friends
    (friends + inverse_friends).uniq
  end
end

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

  has_many :inverse_friendships,
           class_name: "Friendship",
           foreign_key: "friend_id",
           dependent: :destroy

  has_many :inverse_friends,
           through: :inverse_friendships,
           source: :user

  # ========================
  # NAME HELPERS
  # ========================
  def name
    [first_name, last_name].compact.join(" ")
  end

  def initials
    first = first_name.to_s.first
    last = last_name.to_s.first
    "#{first}#{last}".upcase.presence || "U"
  end

  # ========================
  # FRIEND HELPERS
  # ========================
  def all_friends
    (friends + inverse_friends).uniq
  end

  # ========================
  # DEVise OVERRIDE
  # ========================
  def update_with_password(params, *options)
    if params[:password].present?
      # Password change → require current password (Devise default)
      super
    else
      # No password change → allow update without current password
      params.delete(:current_password)

      # Remove blank password fields so Devise doesn't validate them
      if params[:password].blank?
        params.delete(:password)
        params.delete(:password_confirmation)
      end

      # 👇 KEY: use update (not bypassing Devise completely)
      result = update(params, *options)
      clean_up_passwords
      result
    end
  end
end

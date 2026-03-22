class Location < ApplicationRecord
  has_many :scheduled_sessions, dependent: :destroy

  def display_name
    [name, city].compact.join(", ")
  end
end

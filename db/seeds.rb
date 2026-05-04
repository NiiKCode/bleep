# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

puts "🌱 Seeding database..."

# ========================
# CLEAN ONLY TIME-SERIES DATA (SAFE)
# ========================
puts "Cleaning existing bookings + sessions..."

if Rails.env.development?
  Booking.destroy_all
  TimeSlot.destroy_all
  ScheduledSession.destroy_all
end

# ========================
# USERS
# ========================
puts "Creating users..."

admin = User.find_or_initialize_by(email: "admin@bleep.fit")

admin.password = "Yoghurt71375"
admin.password_confirmation = "Yoghurt71375"
admin.admin = true

admin.save!

user = User.find_or_create_by!(email: "test@example.com") do |u|
  u.password = "password"
  u.password_confirmation = "password"
  u.first_name = "James"
  u.last_name = "Branning"
end

friend1 = User.find_or_create_by!(email: "sam@example.com") do |u|
  u.password = "password"
  u.password_confirmation = "password"
  u.first_name = "Sam"
  u.last_name = "Wilson"
end

friend2 = User.find_or_create_by!(email: "ben@example.com") do |u|
  u.password = "password"
  u.password_confirmation = "password"
  u.first_name = "Ben"
  u.last_name = "Evans"
end

# ========================
# FRIENDSHIPS (avoid dupes)
# ========================
puts "Creating friendships..."

[[user, friend1], [user, friend2], [friend1, friend2]].each do |u1, u2|
  Friendship.find_or_create_by!(user: u1, friend: u2)
  Friendship.find_or_create_by!(user: u2, friend: u1)
end

# ========================
# SESSION TYPES
# ========================
puts "Creating session types..."

bleep = SessionType.find_or_create_by!(title: "The Bleep Test")
carry = SessionType.find_or_create_by!(title: "Weighted Carry")

# ========================
# LOCATION
# ========================
puts "Creating location..."

location = Location.find_or_create_by!(name: "Clapham Common", city: "London")

# ========================
# HELPER: CREATE TIME SERIES
# ========================
def create_series(user:, partner:, session_type:, location:, points:, step_days:, base_score:)
  points.times do |i|
    date = (points - i) * step_days
    date = date.days.ago.to_date

    scheduled_session = ScheduledSession.find_or_create_by!(
      date: date,
      location: location,
      session_type: session_type
    ) do |s|
      s.price = 10
    end

    time_slot = TimeSlot.find_or_create_by!(
      start_time: date.to_datetime + 9.hours,
      scheduled_session: scheduled_session
    ) do |t|
      t.end_time = date.to_datetime + 9.hours + 30.minutes
      t.capacity = 10
    end

    Booking.find_or_create_by!(
      user: user,
      time_slot: time_slot,
      partner_user: partner
    ) do |b|
      b.status = "completed"
      b.score = (base_score + i * 0.4 + rand(-0.2..0.2)).round(1)
    end
  end
end

# ========================
# GENERATE DATA (KEY PART)
# ========================
puts "Creating chart-friendly data..."

# ~2 years of weekly data (104 points)
create_series(user: user, partner: nil,     session_type: bleep, location: location, points: 104, step_days: 7, base_score: 6.0)
create_series(user: user, partner: friend1, session_type: bleep, location: location, points: 104, step_days: 7, base_score: 6.5)
create_series(user: user, partner: friend2, session_type: bleep, location: location, points: 104, step_days: 7, base_score: 6.2)

# ~1.5 years bi-weekly
create_series(user: user, partner: nil,     session_type: carry, location: location, points: 40, step_days: 14, base_score: 8.0)

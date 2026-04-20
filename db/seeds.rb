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

user = User.create!(
  email: "test@example.com",
  password: "password",
  password_confirmation: "password",
  first_name: "James",
  last_name: "Branning"
)

friend1 = User.create!(
  email: "sam@example.com",
  password: "password",
  password_confirmation: "password",
  first_name: "Sam",
  last_name: "Wilson"
)

friend2 = User.create!(
  email: "ben@example.com",
  password: "password",
  password_confirmation: "password",
  first_name: "Ben",
  last_name: "Evans"
)

# Friendships
[user, friend1, friend2].combination(2) do |u1, u2|
  u1.friendships.create!(friend: u2)
  u2.friendships.create!(friend: u1)
end

puts "Creating session types..."

bleep = SessionType.create!(title: "Bleep Test Classic")
carry = SessionType.create!(title: "Weighted Carry")
bike  = SessionType.create!(title: "Assault Bike")

session_types = [bleep, carry, bike]

puts "Creating location..."

location = Location.create!(
  name: "Test Gym",
  city: "London"
)

puts "Creating sessions + bookings..."

10.times do |i|
  date = (10 - i).days.ago.to_date
  session_type = session_types.sample

  scheduled_session = ScheduledSession.create!(
    date: date,
    price: 10,
    location: location,
    session_type: session_type
  )

  time_slot = TimeSlot.create!(
    start_time: date.to_datetime + 9.hours,
    end_time: date.to_datetime + 9.hours + 30.minutes,
    capacity: 10,
    scheduled_session: scheduled_session
  )

  partner = [nil, friend1, friend2].sample

  Booking.create!(
    user: user,
    partner_user: partner,
    time_slot: time_slot,
    status: "completed", # optional now (time logic also works)
    score: (rand < 0.7 ? rand(5.0..10.0).round(1) : nil) # some missing scores
  )
end

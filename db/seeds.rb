puts "🌱 Seeding database..."

# ========================
# CLEAN ONLY OLD / TIME-SERIES DATA
# ========================
puts "Cleaning old sessions..."

Booking.joins(:time_slot)
       .where("time_slots.start_time < ?", Time.current)
       .destroy_all

TimeSlot.where("start_time < ?", Time.current).destroy_all
ScheduledSession.where("date < ?", Date.today).destroy_all

# ========================
# USERS
# ========================
puts "Creating users..."

admin = User.find_or_initialize_by(email: "admin@bleep.fit")
admin.password = "Yoghurt71375"
admin.password_confirmation = "Yoghurt71375"
admin.admin = true
admin.save!

user = User.find_or_initialize_by(email: "test@example.com")
user.update!(
  password: "password",
  password_confirmation: "password",
  first_name: "James",
  last_name: "Branning"
)

friend1 = User.find_or_initialize_by(email: "sam@example.com")
friend1.update!(
  password: "password",
  password_confirmation: "password",
  first_name: "Sam",
  last_name: "Wilson"
)

friend2 = User.find_or_initialize_by(email: "ben@example.com")
friend2.update!(
  password: "password",
  password_confirmation: "password",
  first_name: "Ben",
  last_name: "Evans"
)

# ========================
# FRIENDSHIPS
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
# HELPER: CREATE SERIES
# ========================
def create_series(user:, partner:, session_type:, location:, points:, step_days:, base_score:, direction:)
  points.times do |i|
    offset = (i + 1) * step_days

    date =
      if direction == :past
        offset.days.ago.to_date
      else
        offset.days.from_now.to_date
      end

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
# GENERATE DATA
# ========================
puts "Creating data..."

# ------------------------
# FUTURE DATA (for booking UI)
# ------------------------
puts "→ Future sessions..."

create_series(
  user: user,
  partner: nil,
  session_type: bleep,
  location: location,
  points: 26,            # 6 months weekly
  step_days: 7,
  base_score: 6.0,
  direction: :future
)

create_series(
  user: user,
  partner: friend1,
  session_type: bleep,
  location: location,
  points: 26,
  step_days: 7,
  base_score: 6.5,
  direction: :future
)

create_series(
  user: user,
  partner: friend2,
  session_type: bleep,
  location: location,
  points: 26,
  step_days: 7,
  base_score: 6.2,
  direction: :future
)

create_series(
  user: user,
  partner: nil,
  session_type: carry,
  location: location,
  points: 12,            # 3 months bi-weekly
  step_days: 14,
  base_score: 8.0,
  direction: :future
)

# ------------------------
# PAST DATA (for charts)
# ------------------------
puts "→ Past sessions..."

create_series(
  user: user,
  partner: nil,
  session_type: bleep,
  location: location,
  points: 52,            # 1 year weekly history
  step_days: 7,
  base_score: 5.5,
  direction: :past
)

create_series(
  user: user,
  partner: friend1,
  session_type: bleep,
  location: location,
  points: 52,
  step_days: 7,
  base_score: 5.8,
  direction: :past
)

create_series(
  user: user,
  partner: nil,
  session_type: carry,
  location: location,
  points: 24,            # ~1 year bi-weekly
  step_days: 14,
  base_score: 7.5,
  direction: :past
)

puts "✅ Seeding complete"

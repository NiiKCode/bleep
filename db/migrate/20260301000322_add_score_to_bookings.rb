class AddScoreToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :score, :decimal, precision: 4, scale: 1
  end
end

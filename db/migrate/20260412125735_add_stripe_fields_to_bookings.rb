class AddStripeFieldsToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :stripe_session_id, :string
    add_column :bookings, :stripe_payment_intent_id, :string

    add_index :bookings, :stripe_session_id
    add_index :bookings, :stripe_payment_intent_id
  end
end

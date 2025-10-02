class CreateTimeSlots < ActiveRecord::Migration[7.1]
  def change
    create_table :time_slots do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :capacity
      t.references :scheduled_session, null: false, foreign_key: true

      t.timestamps
    end
  end
end

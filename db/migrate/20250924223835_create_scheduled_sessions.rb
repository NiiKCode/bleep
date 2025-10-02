class CreateScheduledSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :scheduled_sessions do |t|
      t.date :date
      t.decimal :price, precision: 5, scale: 2
      t.references :location, null: false, foreign_key: true
      t.references :session_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end

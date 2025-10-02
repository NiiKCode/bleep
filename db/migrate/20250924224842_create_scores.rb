class CreateScores < ActiveRecord::Migration[7.1]
  def change
    create_table :scores do |t|
      t.decimal :value, precision: 4, scale: 2
      t.references :booking, null: false, foreign_key: true

      t.timestamps
    end
  end
end

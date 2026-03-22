class DropScores < ActiveRecord::Migration[7.1]
  def change
    drop_table :scores, if_exists: true
  end
end

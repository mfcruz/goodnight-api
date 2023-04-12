class CreateSleepTimes < ActiveRecord::Migration[7.0]
  def change
    create_table :sleep_times do |t|
      t.datetime :started_at, null: false, default: Time.current
      t.datetime :ended_at
      t.integer :sleep_duration_in_seconds

      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end

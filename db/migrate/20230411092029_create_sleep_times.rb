class CreateSleepTimes < ActiveRecord::Migration[7.0]
  def change
    create_table :sleep_times do |t|
      t.datetime :started_at, null: false, default: Time.current
      t.datetime :ended_at

      t.timestamps
    end
  end
end

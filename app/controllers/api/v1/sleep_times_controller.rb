class Api::V1::SleepTimesController < ApplicationController
  def clock_in
    if current_user.sleep_ongoing?
      render json: { message: "#{current_user.name} is currently sleeping, please clock out first."},
             status: :unprocessable_entity
    else
      sleep_time = current_user.sleep_times.new(started_at: Time.current)
      if sleep_time.save
        sleep_records = current_user.sleep_times.order(created_at: :desc)
        render json: {message: "#{current_user.name} is now sleeping.", data: sleep_records},
               status: :ok
      else
        render json: sleep_time.errors, status: :unprocessable_entity
      end
    end
  end

  def clock_out
    if current_user.sleep_ongoing?
      clock_out_time = Time.current
      sleep_duration = clock_out_time - current_user.ongoing_sleep.started_at
      if current_user.ongoing_sleep.update(ended_at: clock_out_time, 
                                           sleep_duration_in_seconds: sleep_duration)
        render json: {message: "#{current_user.name} is now awake."}, status: :ok
      else
        render json: sleep_time.errors, status: :unprocessable_entity
      end
    else
      render json: { message: "#{current_user.name} is currently awake, please clock in first."},
             status: :unprocessable_entity
    end
  end
end

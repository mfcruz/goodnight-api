class Api::V1::UsersController < ApplicationController
  before_action :validate_followee, only: [:follow, :unfollow]

  def follow
    if current_user.follow!(followee)
      render json: {mesasge: "Successfully followed #{followee.name}"}, status: :ok
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  def unfollow
    if current_user.unfollow!(followee)
      render json: {mesasge: "Successfully unfollowed #{followee.name}"}, status: :ok
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  def followees_sleep_records
    render json: {data: current_user.followees_previous_week_sleep_times}, status: :ok
  end

  private

  def followee
    @followee ||= User.find_by(id: user_params[:followee_id])
  end

  def user_params
    params.permit(:followee_id)
  end

  def validate_followee
    if followee.blank?
      current_user.errors.add(:message, "Followee does not exists.")
      render json: current_user.errors, status: :unprocessable_entity
    end
  end
end

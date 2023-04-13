require 'rails_helper'

RSpec.describe "Api::V1::SleepTimes", type: :request do
  let(:current_user) { create(:user) }

  describe "POST /clock_in" do
    context "clock in successfully" do
      it "clocks in the user" do
        post clock_in_api_v1_user_sleep_times_path(current_user.id), as: :json
        expect(response).to have_http_status(:ok)
        expect(current_user.sleep_times.count).to eq(1)
        expect(current_user.reload).to be_sleep_ongoing
      end
    end

    context "user is currently sleeping" do
      it "cannot clock in the user" do
        create(:sleep_time, user: current_user)
        expected_response = {
          "message" => "#{current_user.name} is currently sleeping, please clock out first."
        }

        post clock_in_api_v1_user_sleep_times_path(current_user.id), as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_json).to eq(expected_response)
      end
    end

    context "user has history of sleep_times" do
      it "clocks in the user" do
        create_list(:sleep_time, 2, user: current_user, ended_at: Time.current)
        
        post clock_in_api_v1_user_sleep_times_path(current_user.id), as: :json
        current_user.reload
        expected_response = {
          "message" => "#{current_user.name} is now sleeping.",
          "data" => current_user.sleep_times.order(created_at: :desc).as_json
        }

        expect(response).to have_http_status(:ok)
        expect(response_json).to eq(expected_response)
        expect(current_user.reload).to be_sleep_ongoing
      end
    end
  end

  describe "PATCH /clock_out" do
    context "clock out successfully" do
      it "clocks out the user" do
        create(:sleep_time, user: current_user)

        patch clock_out_api_v1_user_sleep_times_path(current_user.id), as: :json
        expect(response).to have_http_status(:ok)
        expect(current_user.reload).not_to be_sleep_ongoing
      end
    end

    context "user is currently awake" do
      it "cannot clock out the user" do
        create(:sleep_time, user: current_user, ended_at: Time.current)
        expected_response = {
          "message" => "#{current_user.name} is currently awake, please clock in first."
        }

        patch clock_out_api_v1_user_sleep_times_path(current_user.id), as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_json).to eq(expected_response)
      end
    end
  end
end

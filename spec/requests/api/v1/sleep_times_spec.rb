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
  end
end

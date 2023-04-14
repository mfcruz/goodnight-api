require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let(:current_user) { create(:user) }
  let(:followee) { create(:user) }

  describe "POST /follow" do
    describe "valid parameters" do
      it "follows the followee" do
        post api_v1_user_follow_path(current_user.id, followee.id), as: :json
        expect(response).to have_http_status(:ok)

        current_user.reload
        expect(current_user.followees.count).to eq(1)
        expect(current_user.followees).to include(followee)
      end
    end

    describe "followee does not exists" do
      it "returns an error response" do
        post api_v1_user_follow_path(current_user.id, 0), as: :json
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_json).to eq({"message" => ["Followee does not exists."]})
      end
    end

    describe "already following user" do
      it "returns an error response" do
        current_user.followees << followee
        post api_v1_user_follow_path(current_user.id, followee.id), as: :json
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_json).to eq({"message" => ["You are already following #{followee.name}."]})
      end
    end
  end

  describe "DELETE /unfollow" do
    describe "valid parameters" do
      it "unfollows the followee" do
        current_user.followees << followee
        current_user.followees << create(:user)

        delete api_v1_user_unfollow_path(current_user.id, followee.id), as: :json
        expect(response).to have_http_status(:ok)

        current_user.reload
        expect(current_user.followees.count).to eq(1)
        expect(current_user.followees).not_to include(followee)
      end
    end

    describe "followee does not exists" do
      it "returns an error response" do
        delete api_v1_user_unfollow_path(current_user.id, 0), as: :json
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_json).to eq({"message" => ["Followee does not exists."]})
      end
    end

    describe "not following given user" do
      it "returns an error response" do
        current_user.followees << create(:user)
        delete api_v1_user_unfollow_path(current_user.id, followee.id), as: :json
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_json).to eq({"message" => ["You are not following #{followee.name}."]})
      end
    end
  end

  describe "GET /followees_sleep_records" do
    it "returns sleep times list" do
      followee_1 = create(:user)
      followee_2 = create(:user)
      a_date_last_week = Time.current - 7.days

      list_1 = create_list(:sleep_time, 2, user: followee_1, ended_at: a_date_last_week,
                           created_at: a_date_last_week, sleep_duration_in_seconds: rand(1000))
      create(:sleep_time, user: followee_1)

      list_2 = create_list(:sleep_time, 2, user: followee_2, ended_at: a_date_last_week,
                           created_at: a_date_last_week, sleep_duration_in_seconds: rand(1000))
      create_list(:sleep_time, 3, user: followee_2, ended_at: Time.current)

      current_user.followees << [followee_1, followee_2]
      expected_response = { "data" => (list_1 + list_2).sort_by(&:sleep_duration_in_seconds).as_json }

      get api_v1_user_followees_sleep_records_path(current_user.id), as: :json

      current_user.reload
      expect(response).to have_http_status(:ok)
      expect(response_json).to eq(expected_response)
    end
  end
end

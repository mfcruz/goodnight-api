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
end

# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:current_user) { create(:user) }

  describe "associations" do
    it { should have_many(:sleep_times) }
    it { should have_many(:followed_users).with_foreign_key(:follower_id).class_name("UserFollow") }
    it { should have_many(:followees).through(:followed_users) }
    it { should have_many(:following_users).with_foreign_key(:followee_id).class_name("UserFollow") }
    it { should have_many(:followers).through(:following_users) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "#sleep_ongoing?" do
    context "sleep_times is empty" do
      it "returns false" do
        expect(current_user.sleep_ongoing?).to be_falsy
      end
    end

    context "sleep_times is not empty" do
      it "returns true when ended_at is nil" do
        create(:sleep_time, user: current_user)
        expect(current_user.sleep_ongoing?).to be_truthy
      end

      it "returns false when ended_at has value" do
        create(:sleep_time, user: current_user, ended_at: Time.current)
        expect(current_user.sleep_ongoing?).to be_falsy
      end
    end
  end

  describe "#ongoing_sleep" do
    context "sleep_times is empty" do
      it "returns nil" do
        expect(current_user.ongoing_sleep).to be_nil
      end
    end

    context "sleep_times is not empty" do
      it "returns last sleep_time" do
        sleep_times = create_list(:sleep_time, 3, user: current_user)
        expect(current_user.ongoing_sleep).to eq(sleep_times.last)
      end
    end
  end

  describe "#follow!" do
    let(:followee) { create(:user) }

    it "follows user" do
      expect {
        current_user.follow!(followee)
      }.to change { current_user.followees.count }.by(1)
      expect(current_user.followees).to include(followee)
    end

    context "already following user" do
      it "returns an error" do
        current_user.followees << followee
        current_user.follow!(followee)
        
        expect(current_user.errors.as_json).to eq({ :message => ["You are already following #{followee.name}."] })
      end
    end
  end

  describe "#unfollow!" do
    let(:followee) { create(:user) }

    it "unfollows user" do
      current_user.followees << followee
      current_user.followees << create(:user)

      expect {
        current_user.unfollow!(followee)
      }.to change { current_user.followees.count }.by(-1)
      expect(current_user.followees).not_to include(followee)
    end

    context "not following user" do
      it "returns an error" do
        current_user.unfollow!(followee)
        
        expect(current_user.errors.as_json).to eq({ :message => ["You are not following #{followee.name}."] })
      end
    end
  end
end
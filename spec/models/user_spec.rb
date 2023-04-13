# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:current_user) { create(:user) }

  describe "associations" do
    it { should have_many(:sleep_times) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe ".sleep_ongoing?" do
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

  describe ".ongoing_sleep" do
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
end
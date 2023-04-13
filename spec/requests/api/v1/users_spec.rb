require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let(:current_user) { create(:user) }
  let(:followee) { create(:user) }

  describe "POST /follow" do
    pending "add some examples (or delete) #{__FILE__}"
  end
end

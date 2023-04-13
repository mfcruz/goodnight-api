FactoryBot.define do
  factory :user_follow do
    follower_id { 1 }
    followee_id { 1 }
  end
end

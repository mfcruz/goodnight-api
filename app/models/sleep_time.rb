class SleepTime < ApplicationRecord
  validates :started_at, presence: true

  belongs_to :user
end

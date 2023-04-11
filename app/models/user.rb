class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :sleep_times, dependent: :destroy
end

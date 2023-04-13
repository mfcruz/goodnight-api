class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :sleep_times, dependent: :destroy

  def sleep_ongoing?
    sleep_times.last.present? && sleep_times.last.ended_at.blank?
  end
end

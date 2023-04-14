class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :sleep_times, dependent: :destroy
  
  has_many :followed_users, foreign_key: :follower_id, class_name: 'UserFollow'
  has_many :followees, through: :followed_users
  has_many :following_users, foreign_key: :followee_id, class_name: 'UserFollow'
  has_many :followers, through: :following_users

  def sleep_ongoing?
    sleep_times.last.present? && sleep_times.last.ended_at.blank?
  end

  def ongoing_sleep
    sleep_times.last
  end

  def follow!(followee)
    if followees.exists?(followee.id)
      errors.add(:message, "You are already following #{followee.name}.")
      return false
    end

    followees << followee
  end

  def unfollow!(followee)
    unless followees.exists?(followee.id)
      errors.add(:message, "You are not following #{followee.name}.")
      return false
    end

    followed_users.find_by(followee_id: followee.id).destroy
  end
end

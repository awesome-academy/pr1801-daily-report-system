class Request < ApplicationRecord
  belongs_to :user
  belongs_to :requests_type

  enum status: {pending: 0, approved: 1, rejected: 2}

  scope :search_for_date, -> (search_date) {
    where("updated_at = ?", search_date)
  }

  def verify(manager)
    return false if manager.nil?
    update_columns(status: :approved, sign_date: Time.zone.now)
  end

  def reject(manager)
    return false if manager.nil?
    update_columns(status: :rejected, sign_date: Time.zone.now)
  end

  def correct_user? user
    self.user == user
  end

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end
end

class PostLike < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :user_id, uniqueness: { scope: :post_id }

  def self.ransackable_attributes(auth_object = nil)
    %w[id user_id post_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user post]
  end
end

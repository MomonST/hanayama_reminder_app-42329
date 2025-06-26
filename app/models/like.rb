class Like < ApplicationRecord
  # アソシエーション
  belongs_to :user
  belongs_to :post
  
  # バリデーション
  validates :user_id, uniqueness: { scope: :post_id, message: "既にいいねしています" }
  
  # いいね後に投稿のいいね数を更新
  after_create :update_post_likes_count
  after_destroy :update_post_likes_count

  def self.ransackable_attributes(auth_object = nil)
    %w[id user_id post_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user post]
  end
  
  private
  
  def update_post_likes_count
    post.update_likes_count
  end
end
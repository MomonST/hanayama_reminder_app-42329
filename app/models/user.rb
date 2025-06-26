class User < ApplicationRecord
  # Deviseの設定
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  # アソシエーション
  has_many :notifications, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  
  # お気に入りの花山関連付け（中間テーブル経由）
  has_many :favorite_flower_mountains, through: :favorites, source: :flower_mountain
  
  # バリデーション
  validates :email, presence: true, uniqueness: true
  validates :nickname, presence: true, length: { maximum: 50 }
  
  # 地域の選択肢
  REGIONS = ["北海道", "東北", "関東", "中部", "近畿", "中国", "四国", "九州"]
  validates :region, inclusion: { in: REGIONS }, allow_nil: true

  # ユーザーのフルネーム取得
  def full_name
    "#{last_name} #{first_name}"
  end
  
  # ユーザーのフルネーム（カナ）取得
  def full_name_kana
    "#{last_name_kana} #{first_name_kana}"
  end

  def favorited_flower_mountain?(flower_mountain)
    favorites.exists?(flower_mountain: flower_mountain)
  end

  # ActiveAdminでの検索を許可する属性
  def self.ransackable_attributes(auth_object = nil)
    %w[id email nickname first_name last_name first_name_kana last_name_kana region birth_date created_at updated_at]
  end

  # ActiveAdminでの検索を許可する関連
  def self.ransackable_associations(auth_object = nil)
    %w[posts likes]
  end
end
FactoryBot.define do
  factory :post do
    association :user
    association :flower_mountain
    content { "美しい花を見つけました！" }
    image_url { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/test.jpg"), "image/jpeg") }
    
    # flowerのみ設定
    factory :post_with_flower_only do
      mountain { nil }
    end

    # mountainのみ設定
    factory :post_with_mountain_only do
      flower { nil }
    end

    # 新しい投稿（最近）
    factory :recent_post do
      created_at { 1.day.ago }
    end

    # 古い投稿
    factory :old_post do
      created_at { 1.month.ago }
    end

    # いいねが3つある投稿
    factory :post_with_likes do
      after(:create) do |post|
        create_list(:post_like, 3, post: post)
      end
    end
  end

end

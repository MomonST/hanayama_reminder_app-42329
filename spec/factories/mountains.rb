FactoryBot.define do
  factory :mountain do
    sequence(:name) { |n| "テスト山#{n}" }
    region { "関東" }
    difficulty_level { "中級者" }
    elevation { 1000 }
    latitude { 35.6762 }
    longitude { 139.6503 }
    description { "美しい山です。初心者にもおすすめです。" }
    image_url { "https://example.com/mountain.jpg" }
  end

  factory :high_mountain, parent: :mountain do
    elevation { 3000 }
    description { "高山です。上級者向けです。" }
  end

  factory :low_mountain, parent: :mountain do
    elevation { 500 }
    description { "低山です。初心者向けです。" }
  end

  factory :kanto_mountain, parent: :mountain do
    region { "関東" }
  end

  factory :kinki_mountain, parent: :mountain do
    region { "近畿" }
  end

  factory :intermediate_mountain, parent: :mountain do
    difficulty_level { "中級者" }
  end

  factory :advanced_mountain, parent: :mountain do
    difficulty_level { "上級者" }
  end
end

FactoryBot.define do
  factory :flower do
    sequence(:name) { |n| "テスト花#{n}" }
    scientific_name { "Testus flowerus" }
    description { "美しい花です。春に咲きます。" }
    bloom_start_month { 4 }
    bloom_end_month { 4 }
    image_url { "https://example.com/flower.jpg" }
  end

  factory :spring_flower, parent: :flower do
    bloom_start_month { 4 }
    bloom_end_month { 4 }
    peak_period { "4月中旬" }
  end

  factory :summer_flower, parent: :flower do
    bloom_start_month { 7 }
    bloom_end_month { 7 }
    peak_period { "7月下旬" }
  end
end


FactoryBot.define do
  factory :flower_mountain do
    association :flower
    association :mountain
    peak_month { 4 } # デフォルトは4月
    bloom_info { "見頃の時期です。" }
  end
end

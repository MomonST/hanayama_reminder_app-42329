FactoryBot.define do
  factory :flower_mountain do
    flower
    mountain
    peak_month { 4 }
    bloom_info { "見頃の時期です。" }

    trait :spring_peak do
      peak_month { 4 }
    end

    trait :summer_peak do
      peak_month { 7 }
    end

    trait :autumn_peak do
      peak_month { 10 }
    end
  end
end

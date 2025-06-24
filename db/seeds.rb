require 'open-uri'

# 地域
regions = User::REGIONS

# 花データ
flowers = [
  { name: "ヤマザクラ", scientific_name: "Prunus jamasakura", bloom_start_month: 4, bloom_end_month: 5, 
    description: "日本を代表する桜の一種で、山地に自生しています。",
    remote_image_url_url: "https://hanayama42329.s3.ap-northeast-1.amazonaws.com/flowers/yamazakura.jpg" },
  { name: "ミツバツツジ", scientific_name: "Rhododendron dilatatum", bloom_start_month: 4, bloom_end_month: 5, 
    description: "春に鮮やかなピンク色の花を咲かせる日本固有のツツジです。",
    remote_image_url_url: "https://hanayama42329.s3.ap-northeast-1.amazonaws.com/flowers/mitsubatsutsuji.jpg" },
  { name: "カタクリ", scientific_name: "Erythronium japonicum", bloom_start_month: 3, bloom_end_month: 4, 
    description: "春の妖精とも呼ばれる紫色の花を咲かせる山野草です。",
    remote_image_url_url: "https://hanayama42329.s3.ap-northeast-1.amazonaws.com/flowers/katakuri.jpg" },
  { name: "シャクナゲ", scientific_name: "Rhododendron metternichii", bloom_start_month: 4, bloom_end_month: 6, 
    description: "美しい大輪の花を咲かせる常緑低木です。",
    remote_image_url_url: "https://hanayama42329.s3.ap-northeast-1.amazonaws.com/flowers/shakunage.jpg" },
  { name: "ニッコウキスゲ", scientific_name: "Hemerocallis esculenta", bloom_start_month: 7, bloom_end_month: 8, 
    description: "夏の高原を彩る鮮やかなオレンジ色の花です。",
    remote_image_url_url: "https://hanayama42329.s3.ap-northeast-1.amazonaws.com/flowers/nikkoukisuge.jpg" },
  { name: "レンゲツツジ", scientific_name: "Rhododendron japonicum", bloom_start_month: 5, bloom_end_month: 6, 
    description: "初夏に鮮やかな朱色の花を咲かせるツツジです。",
    remote_image_url_url: "https://hanayama42329.s3.ap-northeast-1.amazonaws.com/flowers/rengetsutsuji.jpg" }
]

# 山データ
mountains = [
  { name: "高尾山", region: "関東", difficulty_level: "初心者", elevation: 599, 
    latitude: 35.6253, longitude: 139.2437, 
    description: "東京都八王子市にある標高599mの山。年間約250万人が訪れる人気の山です。",
    remote_image_url_url: "https://hanayama42329.s3.ap-northeast-1.amazonaws.com/mountains/takaosan.jpg" },
  { name: "筑波山", region: "関東", difficulty_level: "初心者", elevation: 877, 
    latitude: 36.2258, longitude: 140.1069, 
    description: "茨城県つくば市にある標高877mの山。男体山と女体山の双峰からなります。",
    remote_image_url_url: "https://hanayama42329.s3.ap-northeast-1.amazonaws.com/mountains/tsukubayama.jpg" },
  { name: "丹沢山", region: "関東", difficulty_level: "中級者", elevation: 1567, 
    latitude: 35.4731, longitude: 139.1636, 
    description: "神奈川県の丹沢山地の主峰で、標高1567mの山です。",
    remote_image_url_url: "https://hanayama42329.s3.ap-northeast-1.amazonaws.com/mountains/tanzawayama.jpg" },
  { name: "富士山", region: "中部", difficulty_level: "上級者", elevation: 3776, 
    latitude: 35.3606, longitude: 138.7274, 
    description: "日本最高峰の山で、標高3776mの活火山です。",
    remote_image_url_url: "https://hanayama42329.s3.ap-northeast-1.amazonaws.com/mountains/fujisan.jpg" },
  { name: "大山", region: "中国", difficulty_level: "中級者", elevation: 1729, 
    latitude: 35.3711, longitude: 134.1869, 
    description: "鳥取県にある標高1729mの山。中国地方の最高峰です。",
    remote_image_url_url: "https://hanayama42329.s3.ap-northeast-1.amazonaws.com/mountains/daisen.jpg" },
  { name: "屋久島宮之浦岳", region: "九州", difficulty_level: "上級者", elevation: 1936, 
    latitude: 30.3361, longitude: 130.5044, 
    description: "鹿児島県の屋久島にある標高1936mの山。九州最高峰です。",
    remote_image_url_url: "https://hanayama42329.s3.ap-northeast-1.amazonaws.com/mountains/miyanoura.jpg" }
]

# 花データ作成
puts "Creating flowers..."
flowers.each do |flower_data|
  flower = Flower.find_or_initialize_by(name: flower_data[:name])
  flower.scientific_name = flower_data[:scientific_name]
  flower.bloom_start_month = flower_data[:bloom_start_month]
  flower.bloom_end_month = flower_data[:bloom_end_month]
  flower.description = flower_data[:description]
  flower.remote_image_url_url = flower_data[:remote_image_url_url]

  # remote_image_url にURLを直接渡す
  if flower.image_url.blank?
    flower.remote_image_url_url = flower_data[:image_url] # ←ここ
  end

  flower.save!
end

# 山データ作成
puts "Creating mountains..."
mountains.each do |mountain_data|
  mountain = Mountain.find_or_initialize_by(name: mountain_data[:name])
  mountain.region = mountain_data[:region]
  mountain.difficulty_level = mountain_data[:difficulty_level]
  mountain.elevation = mountain_data[:elevation]
  mountain.latitude = mountain_data[:latitude]
  mountain.longitude = mountain_data[:longitude]
  mountain.description = mountain_data[:description]
  mountain.remote_image_url_url = mountain_data[:remote_image_url_url]

  # remote_image_url にURLを直接渡す
  if mountain.image_url.blank?
    mountain.remote_image_url_url = mountain_data[:image_url] # ←ここ
  end

  mountain.save!
end

# 花山データ（中間テーブル）
flower_mountains = [
  { flower_name: "ヤマザクラ", mountain_name: "高尾山", peak_month: 4 },
  { flower_name: "カタクリ", mountain_name: "筑波山", peak_month: 3 },
  { flower_name: "ミツバツツジ", mountain_name: "丹沢山", peak_month: 5 },
  { flower_name: "シャクナゲ", mountain_name: "富士山", peak_month: 6 },
  { flower_name: "ニッコウキスゲ", mountain_name: "富士山", peak_month: 7 },
  { flower_name: "レンゲツツジ", mountain_name: "大山", peak_month: 5 },
  { flower_name: "ヤマザクラ", mountain_name: "筑波山", peak_month: 4 },
  { flower_name: "カタクリ", mountain_name: "高尾山", peak_month: 3 }
]


puts "Creating flower-mountain relationships..."
flower_mountains.each do |fm_data|
  flower = Flower.find_by(name: fm_data[:flower_name])
  mountain = Mountain.find_by(name: fm_data[:mountain_name])
  
  if flower && mountain
    flower_mountain = FlowerMountain.find_or_initialize_by(
      flower_id: flower.id,
      mountain_id: mountain.id
    )
    flower_mountain.peak_month = fm_data[:peak_month]
    flower_mountain.bloom_info = "#{fm_data[:peak_month]}月中旬頃が見頃です。"
    flower_mountain.save!
  end
end

# テストユーザー作成（開発環境のみ）
if Rails.env.development?
  puts "Creating test user..."
  test_user = User.find_or_initialize_by(email: "test@example.com")
  test_user.password = "password"
  test_user.nickname = "テストユーザー"
  test_user.first_name = "花子"
  test_user.last_name = "山田"
  test_user.first_name_kana = "ハナコ"
  test_user.last_name_kana = "ヤマダ"
  test_user.birth_date = Date.new(1990, 1, 1)
  test_user.region = "関東"
  test_user.save!
end

puts "Seed data created successfully!"
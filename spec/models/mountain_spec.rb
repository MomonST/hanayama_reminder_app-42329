require 'rails_helper'

RSpec.describe Mountain, type: :model do
  describe 'バリデーション' do
    it 'ファクトリが有効であること' do
      expect(FactoryBot.build(:mountain)).to be_valid
    end

    it 'nameが必須であること' do
      mountain = FactoryBot.build(:mountain, name: nil)
      expect(mountain).not_to be_valid
      expect(mountain.errors[:name]).to include("を入力してください")
    end

    it 'nameが一意であること' do
      FactoryBot.create(:mountain, name: 'テスト山')
      mountain = FactoryBot.build(:mountain, name: 'テスト山')
      expect(mountain).not_to be_valid
    end

    it 'regionが必須であること' do
      mountain = FactoryBot.build(:mountain, region: nil)
      expect(mountain).not_to be_valid
      expect(mountain.errors[:region]).to include("を入力してください")
    end

    it 'difficulty_levelが有効な値であること' do
      valid_levels = ['初心者', '中級者', '上級者']
      valid_levels.each do |level|
        mountain = FactoryBot.build(:mountain, difficulty_level: level)
        expect(mountain).to be_valid
      end

      mountain = FactoryBot.build(:mountain, difficulty_level: '無効なレベル')
      expect(mountain).not_to be_valid
    end

    it 'elevationが正の整数であること' do
      mountain = FactoryBot.build(:mountain, elevation: -100)
      expect(mountain).not_to be_valid

      mountain = FactoryBot.build(:mountain, elevation: 100.5)
      expect(mountain).not_to be_valid

      mountain = FactoryBot.build(:mountain, elevation: 1000)
      expect(mountain).to be_valid
    end
  end

  describe 'アソシエーション' do
    it 'flower_mountainsとの関連があること' do
      association = described_class.reflect_on_association(:flower_mountains)
      expect(association.macro).to eq :has_many
    end

    it 'flowersとの関連があること' do
      association = described_class.reflect_on_association(:flowers)
      expect(association.macro).to eq :has_many
    end

    it 'postsとの関連があること' do
      association = described_class.reflect_on_association(:posts)
      expect(association.macro).to eq :has_many
    end

    it 'favoritesとの関連があること' do
      association = described_class.reflect_on_association(:favorites)
      expect(association.macro).to eq :has_many
    end
  end

  describe 'スコープ' do
    let!(:kanto_mountain) { FactoryBot.create(:mountain, region: '関東') }
    let!(:kinki_mountain) { FactoryBot.create(:mountain, region: '近畿') }
    let!(:high_mountain) { FactoryBot.create(:mountain, difficulty_level: '上級者', elevation: 3000) }
    let!(:low_mountain) { FactoryBot.create(:mountain, difficulty_level: '初心者', elevation: 500) }

    describe '.by_region' do
      it '指定した地域の山を返すこと' do
        expect(Mountain.by_region('関東')).to include(kanto_mountain)
        expect(Mountain.by_region('関東')).not_to include(kinki_mountain)
      end
    end

    describe '.by_difficulty' do
      it '指定した難易度の山を返すこと' do
        expect(Mountain.by_difficulty('上級者')).to include(high_mountain)
        expect(Mountain.by_difficulty('上級者')).not_to include(low_mountain)
      end
    end

    describe '.by_elevation_range' do
      it '標高範囲で絞り込むこと' do
        result = Mountain.by_elevation_range(1000, 4000)
        expect(result).to include(high_mountain)
        expect(result).not_to include(low_mountain)
      end
    end
  end

  describe 'メソッド' do
    let(:mountain) { FactoryBot.create(:mountain) }

    describe '#has_blooming_flowers?' do
      it '見頃の花がある場合trueを返すこと' do
        flower = FactoryBot.create(:flower, bloom_start_month: Date.current.month, bloom_end_month: Date.current.month)
        FactoryBot.create(:flower_mountain, mountain: mountain, flower: flower)
        expect(mountain.has_blooming_flowers?).to be true
      end

      it '見頃の花がない場合falseを返すこと' do
        flower = FactoryBot.create(:flower, bloom_start_month: 1, bloom_end_month: 2)
        FactoryBot.create(:flower_mountain, mountain: mountain, flower: flower)
        allow(Date).to receive(:today).and_return(Date.new(2025, 6, 15)) # 季節外のテスト用
        expect(mountain.has_blooming_flowers?).to be false
      end
    end

    describe '#favorites_count' do
      it 'お気に入り数を返すこと' do
        flower_mountain = FactoryBot.create(:flower_mountain, mountain: mountain)
        FactoryBot.create_list(:favorite, 3, flower_mountain: flower_mountain)
        expect(mountain.favorites_count).to eq 3
      end
    end
  end
end

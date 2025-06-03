require 'rails_helper'

RSpec.describe Flower, type: :model do
  describe 'バリデーション' do
    it 'ファクトリが有効であること' do
      expect(FactoryBot.build(:flower)).to be_valid
    end

    it 'nameが必須であること' do
      flower = FactoryBot.build(:flower, name: nil)
      expect(flower).not_to be_valid
      expect(flower.errors[:name]).to include("を入力してください")
    end

    it 'nameが一意であること' do
      FactoryBot.create(:flower, name: 'テスト花')
      flower = FactoryBot.build(:flower, name: 'テスト花')
      expect(flower).not_to be_valid
    end

    it 'descriptionが必須であること' do
      flower = FactoryBot.build(:flower, description: nil)
      expect(flower).not_to be_valid
      expect(flower.errors[:description]).to include("を入力してください")
    end

    it 'bloom_start_monthが必須であること' do
      flower = FactoryBot.build(:flower, bloom_start_month: nil)
      expect(flower).not_to be_valid
      expect(flower.errors[:bloom_start_month]).to include("を入力してください")
    end

    it 'bloom_end_monthが必須であること' do
      flower = FactoryBot.build(:flower, bloom_end_month: nil)
      expect(flower).not_to be_valid
      expect(flower.errors[:bloom_end_month]).to include("を入力してください")
    end

    it 'bloom_start_monthが1-12の範囲内であること' do
      expect(FactoryBot.build(:flower, bloom_start_month: 0)).not_to be_valid
      expect(FactoryBot.build(:flower, bloom_start_month: 13)).not_to be_valid
      expect(FactoryBot.build(:flower, bloom_start_month: 6)).to be_valid
    end

    it 'bloom_end_monthが1-12の範囲内であること' do
      expect(FactoryBot.build(:flower, bloom_end_month: 0)).not_to be_valid
      expect(FactoryBot.build(:flower, bloom_end_month: 13)).not_to be_valid
      expect(FactoryBot.build(:flower, bloom_end_month: 8)).to be_valid
    end
  end

  describe 'アソシエーション' do
    it 'flower_mountainsとの関連があること' do
      association = described_class.reflect_on_association(:flower_mountains)
      expect(association.macro).to eq :has_many
    end

    it 'mountainsとの関連があること' do
      association = described_class.reflect_on_association(:mountains)
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
    let!(:spring_flower) { FactoryBot.create(:flower, bloom_start_month: 3, bloom_end_month: 5) }
    let!(:summer_flower) { FactoryBot.create(:flower, bloom_start_month: 6, bloom_end_month: 8) }

    describe '.blooming_now' do
      it '現在の月に咲く花を返すこと' do
        allow(Date).to receive(:current).and_return(Date.new(2024, 4, 15))
        expect(Flower.blooming_now).to include(spring_flower)
        expect(Flower.blooming_now).not_to include(summer_flower)
      end
    end

    describe '.recent' do
      it '作成日時の降順で返すこと' do
        expect(Flower.recent.first.created_at).to be >= Flower.recent.last.created_at
      end
    end
  end

  describe 'メソッド' do
    let(:flower) { FactoryBot.create(:flower, bloom_start_month: 4, bloom_end_month: 5) }

    describe '#blooming_now?' do
      it '現在見頃の場合trueを返すこと' do
        allow(Date).to receive(:current).and_return(Date.new(2024, 4, 15))
        expect(flower.blooming_now?).to be true
      end

      it '見頃でない場合falseを返すこと' do
        allow(Date).to receive(:current).and_return(Date.new(2024, 7, 15))
        expect(flower.blooming_now?).to be false
      end
    end

    describe '#blooming_season' do
      it '開花期間を文字列で返すこと' do
        expect(flower.blooming_season).to eq '4月〜5月'
      end

      it '開始月と終了月が同じ場合は単一月を返すこと' do
        flower.update(bloom_start_month: 4, bloom_end_month: 4)
        expect(flower.blooming_season).to eq '4月'
      end
    end

    describe '#likes_count' do
      it 'いいね数を返すこと' do
        flower_mountain = FactoryBot.create(:flower_mountain, flower: flower)
        FactoryBot.create_list(:post, 3, flower_mountain: flower_mountain, likes_count: 5)
        expect(flower.likes_count).to eq 15
      end
    end

    describe '#favorites_count' do
      it 'お気に入り数を返すこと' do
        flower_mountain = FactoryBot.create(:flower_mountain, flower: flower)
        FactoryBot.create_list(:favorite, 3, flower_mountain: flower_mountain)
        expect(flower.favorites_count).to eq 3
      end
    end
  end
end

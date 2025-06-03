require 'rails_helper'

RSpec.describe FlowerMountain, type: :model do
  describe 'バリデーション' do
    it 'ファクトリが有効であること' do
      expect(FactoryBot.build(:flower_mountain)).to be_valid
    end

    it 'peak_monthが有効な値であること' do
      (1..12).each do |month|
        flower_mountain = FactoryBot.build(:flower_mountain, peak_month: month)
        expect(flower_mountain).to be_valid
      end

      flower_mountain = FactoryBot.build(:flower_mountain, peak_month: 0)
      expect(flower_mountain).not_to be_valid

      flower_mountain = FactoryBot.build(:flower_mountain, peak_month: 13)
      expect(flower_mountain).not_to be_valid
    end

    it 'flower_idとmountain_idの組み合わせが一意であること' do
      flower = FactoryBot.create(:flower)
      mountain = FactoryBot.create(:mountain)
      FactoryBot.create(:flower_mountain, flower: flower, mountain: mountain)
      
      duplicate = FactoryBot.build(:flower_mountain, flower: flower, mountain: mountain)
      expect(duplicate).not_to be_valid
    end
  end

  describe 'アソシエーション' do
    it 'flowerとの関連があること' do
      association = described_class.reflect_on_association(:flower)
      expect(association.macro).to eq :belongs_to
    end

    it 'mountainとの関連があること' do
      association = described_class.reflect_on_association(:mountain)
      expect(association.macro).to eq :belongs_to
    end

    it 'postsとの関連があること' do
      association = described_class.reflect_on_association(:posts)
      expect(association.macro).to eq :has_many
    end

    it 'favoritesとの関連があること' do
      association = described_class.reflect_on_association(:favorites)
      expect(association.macro).to eq :has_many
    end

    it 'notificationsとの関連があること' do
      association = described_class.reflect_on_association(:notifications)
      expect(association.macro).to eq :has_many
    end
  end

  describe 'メソッド' do
    let(:flower_mountain) { FactoryBot.create(:flower_mountain, peak_month: 4) }

    describe '#peak_season' do
      it '見頃の季節を返すこと' do
        expect(flower_mountain.peak_season).to eq '4月'
      end

      it 'peak_monthがない場合は"情報なし"を返すこと' do
        flower_mountain.update(peak_month: nil)
        expect(flower_mountain.peak_season).to eq '情報なし'
      end
    end

    describe '#days_until_peak' do
      it '見頃までの日数を計算すること' do
        allow(Date).to receive(:current).and_return(Date.new(2024, 3, 15))
        result = flower_mountain.days_until_peak
        expect(result).to be_a(Integer)
        expect(result).to be > 0
      end

      it 'peak_monthがない場合nilを返すこと' do
        flower_mountain.update(peak_month: nil)
        expect(flower_mountain.days_until_peak).to be_nil
      end
    end

    describe '#blooming_now?' do
      it '花が見頃の場合trueを返すこと' do
        allow_any_instance_of(Flower).to receive(:blooming_now?).and_return(true)
        expect(flower_mountain.blooming_now?).to be true
      end
    end

    describe '#difficulty_level' do
      it '山の難易度を返すこと' do
        mountain = FactoryBot.create(:mountain, difficulty_level: '中級者')
        flower_mountain = FactoryBot.create(:flower_mountain, mountain: mountain)
        expect(flower_mountain.difficulty_level).to eq '中級者'
      end
    end
  end
end

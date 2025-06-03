require 'rails_helper'

RSpec.describe Favorite, type: :model do
  describe 'バリデーション' do
    it 'ファクトリが有効であること' do
      expect(FactoryBot.build(:favorite)).to be_valid
    end

    it 'user_idとflower_mountain_idの組み合わせが一意であること' do
      user = create(:user)
      flower_mountain = create(:flower_mountain)
      create(:favorite, user: user, flower_mountain: flower_mountain)

      duplicate = build(:favorite, user: user, flower_mountain: flower_mountain)
      expect(duplicate).not_to be_valid
    end
  end

  describe 'アソシエーション' do
    it 'userとの関連があること' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'flower_mountainとの関連があること' do
      association = described_class.reflect_on_association(:flower_mountain)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe 'スコープ' do
    let!(:flower1) { create(:flower) }
    let!(:flower2) { create(:flower) }
    let!(:mountain1) { create(:mountain) }
    let!(:mountain2) { create(:mountain) }
    let!(:flower_mountain1) { create(:flower_mountain, flower: flower1, mountain: mountain1) }
    let!(:flower_mountain2) { create(:flower_mountain, flower: flower2, mountain: mountain2) }
    let!(:favorite1) { create(:favorite, flower_mountain: flower_mountain1) }
    let!(:favorite2) { create(:favorite, flower_mountain: flower_mountain2) }

    describe '.recent' do
      it '作成日時の降順で返すこと' do
        expect(Favorite.recent.first).to eq favorite2
        expect(Favorite.recent.last).to eq favorite1
      end
    end

    describe '.by_flower' do
      it '指定した花のお気に入りを返すこと' do
        expect(Favorite.by_flower(flower1.id)).to include(favorite1)
        expect(Favorite.by_flower(flower1.id)).not_to include(favorite2)
      end
    end

    describe '.by_mountain' do
      it '指定した山のお気に入りを返すこと' do
        expect(Favorite.by_mountain(mountain1.id)).to include(favorite1)
        expect(Favorite.by_mountain(mountain1.id)).not_to include(favorite2)
      end
    end
  end

  describe 'メソッド' do
    let(:favorite) { create(:favorite) }

    describe '#flower' do
      it '関連する花を返すこと' do
        expect(favorite.flower).to eq favorite.flower_mountain.flower
      end
    end

    describe '#mountain' do
      it '関連する山を返すこと' do
        expect(favorite.mountain).to eq favorite.flower_mountain.mountain
      end
    end
  end
end

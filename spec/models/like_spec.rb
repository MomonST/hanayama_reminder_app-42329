require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'バリデーション' do
    it 'ファクトリが有効であること' do
      expect(FactoryBot.build(:like)).to be_valid
    end

    it 'user_idとpost_idの組み合わせが一意であること' do
      like = FactoryBot.create(:like)
      duplicate = FactoryBot.build(:like, user: like.user, post: like.post)
      expect(duplicate).not_to be_valid
    end
  end

  describe 'アソシエーション' do
    it 'userとの関連があること' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'postとの関連があること' do
      association = described_class.reflect_on_association(:post)
      expect(association.macro).to eq :belongs_to
    end
  end
end

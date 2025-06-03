require 'rails_helper'

RSpec.describe PostLike, type: :model do
  describe 'バリデーション' do
    it 'ファクトリが有効であること' do
      expect(FactoryBot.build(:post_like)).to be_valid
    end

    it 'user_idとpost_idの組み合わせが一意であること' do
      post_like = FactoryBot.create(:post_like)
      duplicate = FactoryBot.build(:post_like, user: post_like.user, post: post_like.post)
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

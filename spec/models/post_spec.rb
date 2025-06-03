require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'バリデーション' do
    it 'ファクトリが有効であること' do
      expect(FactoryBot.build(:post)).to be_valid
    end

    it 'contentが必須であること' do
      post = FactoryBot.build(:post, content: nil)
      expect(post).not_to be_valid
      expect(post.errors[:content]).to include("を入力してください")
    end

    it 'image_urlが必須であること' do
      post = FactoryBot.build(:post, image_url: nil)
      expect(post).not_to be_valid
      expect(post.errors[:image_url]).to include("を入力してください")
    end

    it 'flower_mountainが空だと無効' do
      post = FactoryBot.build(:post, flower_mountain: nil)
      expect(post).not_to be_valid
      expect(post.errors[:flower_mountain]).to include("を入力してください")
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

    it 'post_likesとの関連があること' do
      association = described_class.reflect_on_association(:post_likes)
      expect(association.macro).to eq :has_many
    end
  end

  describe 'スコープ' do
    let!(:recent_post) { FactoryBot.create(:post, created_at: 1.hour.ago) }
    let!(:old_post) { FactoryBot.create(:post, created_at: 1.month.ago) }
    let!(:popular_post) do
      post = FactoryBot.create(:post)
      FactoryBot.create_list(:post_like, 3, post: post)
      post
    end

    #describe '.recent' do
      #it '作成日時の降順で返すこと' do
        #expect(Post.recent.first).to eq recent_post
      #end
    #end

    describe '.oldest' do
      it '作成日時の昇順で返すこと' do
        expect(Post.oldest.first).to eq old_post
      end
    end

    describe '.popular' do
      it 'いいね数の多い順で返すこと' do
        expect(Post.popular.first).to eq popular_post
      end
    end
  end

  describe 'メソッド' do
    let(:post) { FactoryBot.create(:post) }

    describe '#likes_count' do
      it 'いいね数を返すこと' do
        FactoryBot.create_list(:post_like, 5, post: post)
        expect(post.likes_count).to eq 5
      end
    end
  end
end

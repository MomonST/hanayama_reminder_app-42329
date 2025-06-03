require 'rails_helper'

RSpec.describe User, type: :model do
  # FactoryBotを使ったユーザーの作成
  before do
    @user = FactoryBot.build(:user)
  end
  
  describe 'バリデーション' do
    it '有効なファクトリを持つこと' do
      expect(@user).to be_valid
    end

    it 'ニックネームが必須であること' do
      @user.nickname = nil
      expect(@user).not_to be_valid
      expect(@user.errors.full_messages).to include("ニックネームを入力してください")
    end

    it 'メールアドレスが必須であること' do
      @user.email = nil
      expect(@user).not_to be_valid
    end

    it 'メールアドレスが一意であること' do
      FactoryBot.create(:user, email: 'test@example.com')
      @user.email = 'test@example.com'
      expect(@user).not_to be_valid
    end

    it 'emailは@を含まないと登録できない' do
      @user.email = 'testmail'
      @user.valid?
      expect(@user.errors.full_messages).to include('メールアドレスは不正な値です')
    end

    it 'passwordとpassword_confirmationが不一致では登録できない' do
      @user.password = '123456'
      @user.password_confirmation = '1234567'
      @user.valid?
      expect(@user.errors.full_messages).to include("Password confirmationとパスワードの入力が一致しません")
    end

    it 'パスワードが6文字以上であること' do
      @user.password = '12345'
      @user.password_confirmation = '12345'
      expect(@user).not_to be_valid
    end

    it '地域が有効な値であること' do
      @user.region = '無効な地域'
      expect(@user).not_to be_valid
    end

    it '地域が空でも有効であること' do
      @user.region = nil
      expect(@user).to be_valid
    end
  end

  describe 'アソシエーション' do
    it 'postsとの関連があること' do
      association = described_class.reflect_on_association(:posts)
      expect(association.macro).to eq :has_many
    end

    it 'likesとの関連があること' do
      association = described_class.reflect_on_association(:likes)
      expect(association.macro).to eq :has_many
    end

    it 'notificationsとの関連があること' do
      association = described_class.reflect_on_association(:notifications)
      expect(association.macro).to eq :has_many
    end

    it 'favoritesとの関連があること' do
      association = described_class.reflect_on_association(:favorites)
      expect(association.macro).to eq :has_many
    end

    it 'favorite_flowersとの関連があること' do
      association = described_class.reflect_on_association(:favorite_flowers)
      expect(association.macro).to eq :has_many
    end

    it 'favorite_mountainsとの関連があること' do
      association = described_class.reflect_on_association(:favorite_mountains)
      expect(association.macro).to eq :has_many
    end
  end

  describe 'メソッド' do

    describe '#full_name' do
      it 'フルネームを返すこと' do
        @user.last_name = '山田'
        @user.first_name = '太郎'
        expect(@user.full_name).to eq '山田 太郎'
      end
    end

    describe '#full_name_kana' do
      it 'フルネーム（カナ）を返すこと' do
        @user.last_name_kana = 'ヤマダ'
        @user.first_name_kana = 'タロウ'
        expect(@user.full_name_kana).to eq 'ヤマダ タロウ'
      end
    end

    describe '#favorited_flower?' do
      let(:flower) { create(:flower) }

      it 'お気に入りに登録済みの場合trueを返すこと' do
        create(:favorite, :flower_favorite, user: user, flower: flower)
        expect(user.favorited_flower?(flower)).to be true
      end

      it 'お気に入りに未登録の場合falseを返すこと' do
        expect(user.favorited_flower?(flower)).to be false
      end
    end

    describe '#favorited_mountain?' do
      let(:mountain) { create(:mountain) }

      it 'お気に入りに登録済みの場合trueを返すこと' do
        create(:favorite, :mountain_favorite, user: user, mountain: mountain)
        expect(user.favorited_mountain?(mountain)).to be true
      end

      it 'お気に入りに未登録の場合falseを返すこと' do
        expect(user.favorited_mountain?(mountain)).to be false
      end
    end
  end
end

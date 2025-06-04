require 'rails_helper'

RSpec.describe 'ユーザー管理', type: :system do
  let(:user) { FactoryBot.build(:user) } # buildなのでDBには登録しない

  describe 'ユーザー新規登録' do
    before do
      visit new_user_registration_path
    end

    context '新規登録が成功する場合' do
      it '正しい情報を入力すれば新規登録できてトップページに移動する' do
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        fill_in 'パスワード（確認）', with: user.password_confirmation
        fill_in 'ニックネーム', with: user.nickname
        fill_in '姓', with: user.last_name
        fill_in '名', with: user.first_name
        fill_in '姓（カナ）', with: user.last_name_kana
        fill_in '名（カナ）', with: user.first_name_kana
        fill_in '生年月日', with: user.birth_date
        select '関東', from: 'お住まいの地域'
        expect {
          click_button 'アカウントを作成'
          sleep 1
        }.to change { User.count }.by(1)
        expect(page).to have_current_path(root_path)
        expect(page).to have_content 'ログアウト'
      end
    end

    context '新規登録が失敗する場合' do
      it '誤った情報では登録できずに戻される' do
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: ''
        fill_in 'パスワード（確認）', with: ''
        fill_in 'ニックネーム', with: ''
        fill_in '姓', with: ''
        fill_in '名', with: ''
        fill_in '姓（カナ）', with: ''
        fill_in '名（カナ）', with: ''
        fill_in '生年月日', with: ''
        select '選択してください', from: 'お住まいの地域'
        click_button 'アカウントを作成'
        expect(page).to have_current_path('/users/sign_up')
        expect(page).to have_content 'エラー'
      end
    end
  end

  describe 'ユーザーログイン' do
    let!(:registered_user) { FactoryBot.create(:user) } # 既に登録されているユーザー

    before do
      visit new_user_session_path
    end

    context 'ログインが成功する場合' do
      it '正しい情報を入力すればログインできる' do
        fill_in 'メールアドレス', with: registered_user.email
        fill_in 'パスワード', with: registered_user.password
        click_button 'ログイン'
        expect(page).to have_current_path(root_path)
        expect(page).to have_content 'ログアウト'
      end
    end

    context 'ログインが失敗する場合' do
      it '誤った情報ではログインできない' do
        fill_in 'メールアドレス', with: 'wrong@example.com'
        fill_in 'パスワード', with: 'wrongpassword'
        click_button 'ログイン'
        expect(page).to have_current_path('/users/sign_in')
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      end
    end
  end
end

ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :email, :encrypted_password, :nickname, :first_name, :last_name, :first_name_kana, :last_name_kana, :birth_date, :region

  # 必要なものだけフィルターを定義（任意）
  filter :email
  filter :nickname
  filter :region
  filter :created_at

  index do
    selectable_column
    id_column
    column :email
    column :nickname
    column :region
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :nickname
      f.input :first_name
      f.input :last_name
      f.input :first_name_kana
      f.input :last_name_kana
      f.input :birth_date, as: :datepicker
      f.input :region
      # パスワード変更は必要な場合だけ実装してもOK（encrypted_passwordは普通いじらない）
    end
    f.actions
  end
end

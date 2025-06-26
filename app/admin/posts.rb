ActiveAdmin.register Post do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :user_id, :flower_mountain_id, :mountain_id, :content, :image_url, :likes_count

  # 必要なものだけフィルターを定義（任意）
  filter :content
  filter :user_id
  filter :flower_mountain_id
  filter :mountain_id
  filter :created_at

  index do
    selectable_column
    id_column
    column :content
    column :user
    column :flower_mountain
    column :mountain
    column :likes_count
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :user
      f.input :flower_mountain
      f.input :mountain
      f.input :content
      f.input :image_url, as: :file
      f.input :likes_count
    end
    f.actions
  end
end

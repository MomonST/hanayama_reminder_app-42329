ActiveAdmin.register FlowerMountain do
  permit_params :flower_id, :mountain_id, :peak_month, :bloom_info, :auto_generated

  index do
    selectable_column
    id_column
    column :flower
    column :mountain
    column :peak_month
    column :bloom_info
    column("自動生成?") do |fm|
      fm.auto_generated ? status_tag("Yes", class: "status-warning") : status_tag("No", class: "status-ok")
    end
    column :created_at
    actions
  end

  # フィルターを設定
  filter :flower
  filter :mountain
  filter :peak_month
  filter :auto_generated

  form do |f|
    f.inputs "花と山の組み合わせ" do
      f.input :flower
      f.input :mountain
      f.input :peak_month
      f.input :bloom_info
      f.input :auto_generated, label: "自動生成かどうか"
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :flower
      row :mountain
      row :peak_month
      row :bloom_info
      row("自動生成?") { |fm| fm.auto_generated ? status_tag("Yes", class: "status-warning") : status_tag("No", class: "status-ok") }
      row :created_at
      row :updated_at
    end
  end
end

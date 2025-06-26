# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    columns do
      column do
        panel "最新の投稿（Post）" do
          ul do
            Post.order(created_at: :desc).limit(5).map do |post|
              li link_to("#{post.user.nickname}さんの投稿", admin_post_path(post))
            end
          end
        end
      end

      column do
        panel "登録済みデータ数" do
          para "花: #{Flower.count} 件"
          para "山: #{Mountain.count} 件"
          para "ユーザー: #{User.count} 人"
        end
      end
    end
  end # content
end

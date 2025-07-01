class HomeController < ApplicationController
  def index
    # 未ログインの場合は紹介ページを表示
    unless user_signed_in?
      @regions = User::REGIONS
      return
    end
    
    # ログイン済みの場合はダッシュボードを表示
    @user = current_user
    @region = params[:region] || current_user.region || "関東"
    @regions = User::REGIONS
    
    # 選択された地域の花山情報を取得
    @flower_mountains = FlowerMountain.joins(:mountain)
                                     .where(mountains: { region: @region })
                                     .includes(:flower, :mountain)
                                     .select('flower_mountains.*, mountains.difficulty_level, ABS(peak_month - 6) AS days_until_peak')
                                     .order(Arel.sql('ABS(peak_month - 6)'))
                                     .limit(6)
    
    # 通知設定済みの花山情報を取得
    @notifications = current_user.notifications
                                .includes(flower_mountain: [:flower, :mountain])
                                .order(:notification_date)
                                .limit(4)
    
    # 人気の投稿を取得
    @popular_posts = Post.popular.includes(:user, :flower, :mountain).limit(3)

    # 現在見頃の花
    @blooming_flowers = Flower.blooming_now.limit(4)

    # 人気の山
    @popular_mountains = Mountain.left_joins(:posts)
                                .group(:id)
                                .order('COUNT(posts.id) DESC')
                                .limit(3)

    # 最新の投稿
    @recent_posts = Post.includes(:user, :flower, :mountain)
                        .recent
                        .limit(6)

    # 地域別の山の数
    @regions_count = Mountain.group(:region)
                             .count
                             .sort_by { |_, count| -count }
                             .first(5)
                             .to_h
    
    # ログインしている場合は未読通知を取得
    if user_signed_in?
      @unread_notifications = current_user.notifications
                                           .unread
                                           .recent
                                           .limit(5)
    end
  end
  
  def about
    # アプリの紹介ページ
  end
end

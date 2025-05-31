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
                                     .order("ABS(peak_month - #{Date.today.month})")
                                     .limit(6)
    
    # 通知設定済みの花山情報を取得
    @notifications = current_user.notifications
                                .includes(flower_mountain: [:flower, :mountain])
                                .order(:notification_date)
                                .limit(4)
    
    # 人気の投稿を取得
    @popular_posts = Post.popular.includes(:user, flower_mountain: [:flower, :mountain]).limit(3)
  end
  
  def about
    # アプリの紹介ページ
  end
end
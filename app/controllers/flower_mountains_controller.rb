class FlowerMountainsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  
  def index
    @region = params[:region] || "関東"
    @month = params[:month]&.to_i || Date.today.month
    @difficulty = params[:difficulty]
    
    @flower_mountains = FlowerMountain.includes(:flower, :mountain)
    
    # 地域でフィルタリング
    @flower_mountains = @flower_mountains.joins(:mountain).where(mountains: { region: @region }) if @region.present?
    
    # 月でフィルタリング
    @flower_mountains = @flower_mountains.where(peak_month: @month) if @month.present?
    
    # 難易度でフィルタリング
    @flower_mountains = @flower_mountains.joins(:mountain).where(mountains: { difficulty_level: @difficulty }) if @difficulty.present?
    
    # マップ表示用のデータ準備
    @map_data = @flower_mountains.map do |fm|
      {
        id: fm.id,
        name: fm.mountain.name,
        flower: fm.flower.name,
        lat: fm.mountain.latitude,
        lng: fm.mountain.longitude,
        difficulty: fm.mountain.difficulty_level,
        peak_month: fm.peak_month,
        days_left: fm.days_until_peak
      }
    end
    
    # format.json はAPIコントローラーに一任するため削除を推奨
    #respond_to do |format|
      #format.html
      #format.json { render json: @map_data }
    #end
  end
  
  def show
    @flower_mountain = FlowerMountain.includes(:flower, :mountain).find(params[:id])
    @posts = Post.where(flower_id: @flower_mountain.flower_id, mountain_id: @flower_mountain.mountain_id)
                  .recent
                  .includes(:user)
                  .page(params[:page])
                  .per(5)

    # 関連する花山の取得
    @related_flower_mountains = FlowerMountain.where(flower_id: @flower_mountain.flower_id)
                                              .where.not(id: @flower_mountain.id)
                                              .to_a  # ← 結果がnilにならない！
    
    # ログイン済みの場合、お気に入り状態を確認
    if user_signed_in?
      @favorite = current_user.favorites.find_by(flower_mountain_id: @flower_mountain.id)
      @notification = current_user.notifications.find_by(flower_mountain_id: @flower_mountain.id)
    end
  end
end

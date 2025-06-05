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
    
    respond_to do |format|
      format.html
      format.json { render json: @map_data }
    end
  end
  
  def show
    @flower_mountain = FlowerMountain.includes(:flower, :mountain).find(params[:id])
    @posts = @flower_mountain.posts.recent.includes(:user).page(params[:page]).per(5)
    
    # ログイン済みの場合、お気に入り状態を確認
    if user_signed_in?
      @favorite = current_user.favorites.find_by(flower_mountain_id: @flower_mountain.id)
      @notification = current_user.notifications.find_by(flower_mountain_id: @flower_mountain.id)
    end
  end
end

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
      @notification = current_user.notifications.find_by(
        flower_id: @flower_mountain.flower_id,
        mountain_id: @flower_mountain.mountain_id
      )
    end
  end

  def show_by_ids
    @flower = Flower.find(params[:flower_id])
    @mountain = Mountain.find(params[:mountain_id])

    # FlowerMountainが既存になければ自動作成（仮データとして）
    @flower_mountain = FlowerMountain.find_or_initialize_by(flower: @flower, mountain: @mountain)
    
    if @flower_mountain.new_record?
      @flower_mountain.peak_month ||= @flower.bloom_start_month
      @flower_mountain.bloom_info ||= "#{@flower.name}の見頃情報に基づいて自動生成されたデータです"
      @flower_mountain.auto_generated = true if @flower_mountain.respond_to?(:auto_generated)
    
      if @flower_mountain.save
        flash[:notice] = "この花と山の組み合わせは自動生成されました。内容は仮情報です。"
      else
        redirect_to root_path, alert: "この組み合わせは登録できませんでした。" and return
      end
    end

    redirect_to flower_mountain_path(@flower_mountain)
  end
end

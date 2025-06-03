class FlowersController < ApplicationController
  before_action :set_flower, only: [:show]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :admin_required, only: [:new, :create, :edit, :update, :destroy]

  def index
    @flowers = Flower.includes(:flower_mountains, :mountains)
    
    # 検索・フィルタリング
    if params[:search].present?
      @flowers = @flowers.where("name ILIKE ? OR scientific_name ILIKE ?", 
                               "%#{params[:search]}%", "%#{params[:search]}%")
    end
    
    if params[:blooming_season].present?
      @flowers = @flowers.where(blooming_season: params[:blooming_season])
    end
    
    if params[:region].present?
      @flowers = @flowers.joins(:mountains).where(mountains: { region: params[:region] })
    end
    
    if params[:difficulty].present?
      @flowers = @flowers.joins(:flower_mountains).where(flower_mountains: { difficulty_level: params[:difficulty] })
    end
    
    # ソート
    case params[:sort]
    when 'name'
      @flowers = @flowers.order(:name)
    when 'season'
      @flowers = @flowers.order(:blooming_season)
    when 'popular'
      @flowers = @flowers.left_joins(:likes).group(:id).order('COUNT(likes.id) DESC')
    else
      @flowers = @flowers.order(:name)
    end
    
    @flowers = @flowers.page(params[:page]).per(12)
    
    # 統計情報
    @total_flowers = Flower.count
    @blooming_now = Flower.blooming_now.count
    @regions = Mountain.distinct.pluck(:region).compact.sort
    @seasons = Flower.distinct.pluck(:blooming_season).compact.sort
  end

  def show
    @flower_mountains = @flower.flower_mountains.includes(:mountain, :posts)
    @recent_posts = @flower.posts.recent.includes(:user).limit(6)
    @is_liked = user_signed_in? ? current_user.likes.exists?(flower: @flower) : false
    @likes_count = @flower.likes.count
    
    # 関連する花（同じ季節の花）
    @related_flowers = Flower.where(blooming_season: @flower.blooming_season)
                            .where.not(id: @flower.id)
                            .limit(4)
    
    # 地図用データ
    @map_data = @flower_mountains.map do |fm|
      {
        id: fm.id,
        name: fm.mountain.name,
        flower: @flower.name,
        lat: fm.mountain.latitude,
        lng: fm.mountain.longitude,
        difficulty: fm.difficulty_level,
        days_left: fm.days_until_peak
      }
    end
    
    content_for :use_google_maps, true
  end

  def new
    @flower = Flower.new
  end

  def create
    @flower = Flower.new(flower_params)
    
    if @flower.save
      redirect_to @flower, notice: '花の情報が正常に作成されました。'
    else
      render :new
    end
  end

  def edit
    @flower = Flower.find(params[:id])
  end

  def update
    @flower = Flower.find(params[:id])
    
    if @flower.update(flower_params)
      redirect_to @flower, notice: '花の情報が正常に更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @flower = Flower.find(params[:id])
    @flower.destroy
    redirect_to flowers_path, notice: '花の情報が削除されました。'
  end

  # いいね機能
  def like
    @flower = Flower.find(params[:id])
    
    if current_user.likes.exists?(flower: @flower)
      current_user.likes.find_by(flower: @flower).destroy
      liked = false
    else
      current_user.likes.create(flower: @flower)
      liked = true
    end
    
    respond_to do |format|
      format.json { 
        render json: { 
          success: true, 
          liked: liked, 
          likes_count: @flower.likes.count 
        } 
      }
      format.html { redirect_back(fallback_location: @flower) }
    end
  end

  private

  def set_flower
    @flower = Flower.find(params[:id])
  end

  def flower_params
    params.require(:flower).permit(:name, :scientific_name, :description, :blooming_season, 
                                  :peak_period, :image_url, :characteristics, :habitat)
  end

  def admin_required
    redirect_to root_path, alert: '管理者権限が必要です。' unless current_user&.admin?
  end
end
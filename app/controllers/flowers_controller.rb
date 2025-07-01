class FlowersController < ApplicationController
  before_action :set_flower, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  #before_action :admin_required, only: [:new, :create, :edit, :update, :destroy]

  def index
    @flowers = Flower.includes(:flower_mountains, :mountains)
    
    # 検索・フィルタリング
    if params[:search].present?
      @flowers = @flowers.where("name LIKE ? OR scientific_name LIKE ?", 
                               "%#{params[:search]}%", "%#{params[:search]}%")
    end
    
    if params[:region].present?
      @flowers = @flowers.joins(:mountains).where(mountains: { region: params[:region] })
    end
    
    if params[:difficulty].present?
      @flowers = @flowers.joins(flower_mountains: :mountain).where(mountains: { difficulty_level: params[:difficulty] })
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
    @seasons = Flower.all.map(&:blooming_season).compact.uniq.sort
  end

  def show
    @flower_mountains = @flower.flower_mountains.includes(:mountain)
    @recent_posts = Post.where(flower_id: @flower.id).order(created_at: :desc).limit(6)
    
    # いいね機能：flowers_controller.rb の showアクションに追加
    @favorites_count = Favorite.joins(:flower_mountain).where(flower_mountains: { flower_id: @flower.id }).count
    # いいね機能：「ユーザーがお気に入りにしてるか」も必要なら
    @is_favorited = user_signed_in? ? current_user.favorites.joins(:flower_mountain).exists?(flower_mountains: { flower_id: @flower.id }) : false
    # いいね機能：flowerに関連する「投稿のいいね合計」を表示する場合
    @total_post_likes = Post.where(flower_id: @flower.id).joins(:post_likes).count
    
    # 関連する花（同じ季節の花）
    @related_flowers = Flower.all
      .select { |f| f.blooming_season == @flower.blooming_season && f.id != @flower.id }
      .first(4)
    
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
  end

  def update
    if @flower.update(flower_params)
      redirect_to @flower, notice: '花の情報が正常に更新されました。'
    else
      render :edit
    end
  end

  def destroy
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
end
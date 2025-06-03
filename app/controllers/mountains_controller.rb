class MountainsController < ApplicationController
  before_action :set_mountain, only: [:show]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :admin_required, only: [:new, :create, :edit, :update, :destroy]

  def index
    @mountains = Mountain.includes(:flower_mountains, :flowers)
    
    # 検索・フィルタリング
    if params[:search].present?
      @mountains = @mountains.where("name ILIKE ? OR description ILIKE ?", 
                                  "%#{params[:search]}%", "%#{params[:search]}%")
    end
    
    if params[:region].present?
      @mountains = @mountains.where(region: params[:region])
    end
    
    if params[:difficulty].present?
      @mountains = @mountains.joins(:flower_mountains)
                           .where(flower_mountains: { difficulty_level: params[:difficulty] })
                           .distinct
    end
    
    if params[:elevation_min].present?
      @mountains = @mountains.where("elevation >= ?", params[:elevation_min])
    end
    
    if params[:elevation_max].present?
      @mountains = @mountains.where("elevation <= ?", params[:elevation_max])
    end
    
    # ソート
    case params[:sort]
    when 'name'
      @mountains = @mountains.order(:name)
    when 'elevation'
      @mountains = @mountains.order(elevation: :desc)
    when 'popular'
      @mountains = @mountains.left_joins(:posts).group(:id).order('COUNT(posts.id) DESC')
    else
      @mountains = @mountains.order(:name)
    end
    
    @mountains = @mountains.page(params[:page]).per(12)
    
    # 統計情報
    @total_mountains = Mountain.count
    @regions = Mountain.distinct.pluck(:region).compact.sort
    @max_elevation = Mountain.maximum(:elevation)
    @min_elevation = Mountain.minimum(:elevation)
    
    # 地図用データ
    @map_data = @mountains.map do |mountain|
      {
        id: mountain.id,
        name: mountain.name,
        lat: mountain.latitude,
        lng: mountain.longitude,
        region: mountain.region,
        elevation: mountain.elevation,
        flowers_count: mountain.flowers.count
      }
    end
    
    content_for :use_google_maps, true
  end

  def show
    @flower_mountains = @mountain.flower_mountains.includes(:flower)
    @recent_posts = @mountain.posts.recent.includes(:user).limit(6)
    
    # 現在見頃の花
    @blooming_now = @mountain.flowers.select(&:blooming_now?)
    
    # 地図用データ
    @map_data = [{
      id: @mountain.id,
      name: @mountain.name,
      lat: @mountain.latitude,
      lng: @mountain.longitude,
      region: @mountain.region,
      elevation: @mountain.elevation
    }]
    
    # 近くの山
    if @mountain.latitude && @mountain.longitude
      @nearby_mountains = Mountain.where.not(id: @mountain.id)
                                 .near([@mountain.latitude, @mountain.longitude], 50)
                                 .limit(3)
    else
      @nearby_mountains = []
    end
    
    content_for :use_google_maps, true
  end

  def new
    @mountain = Mountain.new
  end

  def create
    @mountain = Mountain.new(mountain_params)
    
    if @mountain.save
      redirect_to @mountain, notice: '山の情報が正常に作成されました。'
    else
      render :new
    end
  end

  def edit
    @mountain = Mountain.find(params[:id])
  end

  def update
    @mountain = Mountain.find(params[:id])
    
    if @mountain.update(mountain_params)
      redirect_to @mountain, notice: '山の情報が正常に更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @mountain = Mountain.find(params[:id])
    @mountain.destroy
    redirect_to mountains_path, notice: '山の情報が削除されました。'
  end

  private

  def set_mountain
    @mountain = Mountain.find(params[:id])
  end

  def mountain_params
    params.require(:mountain).permit(:name, :description, :region, :elevation, 
                                    :latitude, :longitude, :access_info, 
                                    :trail_info, :image_url)
  end

  def admin_required
    redirect_to root_path, alert: '管理者権限が必要です。' unless current_user&.admin?
  end
end
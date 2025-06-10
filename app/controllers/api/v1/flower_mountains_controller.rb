class Api::V1::FlowerMountainsController < ApplicationController
  def index
    @flower_mountains = FlowerMountain.includes(:flower, :mountain)
    
    # フィルタリング
    @flower_mountains = @flower_mountains.joins(:mountain).where(mountains: { region: params[:region] }) if params[:region].present?
    @flower_mountains = @flower_mountains.where(peak_month: params[:month]) if params[:month].present?
    

    # --- 外部APIからの追加情報を取得 (パフォーマンス改善の検討) ---
    # まず必要な地域をすべて抽出し、一度に天気データを取得する
    regions = @flower_mountains.map { |fm| fm.mountain.region }.uniq.compact
    weather_data_by_region = {}
    regions.each do |region|
      weather_data_by_region[region] = WeatherApiService.get_bloom_forecast(region)
    end
    # --- ここまでパフォーマンス改善 ---

    # 外部APIからの追加情報を取得
    enhanced_data = @flower_mountains.map do |fm|
      weather_data = weather_data_by_region(fm.mountain.region)
      
      {
        id: fm.id,
        flower: {
          name: fm.flower.name,
          scientific_name: fm.flower.scientific_name,
          bloom_period: "#{fm.flower.bloom_start_month}月〜#{fm.flower.bloom_end_month}月",
          description: fm.flower.description,
          image_url: fm.flower.image_url&.url
        },
        mountain: {
          name: fm.mountain.name,
          region: fm.mountain.region,
          elevation: fm.mountain.elevation,
          latitude: fm.mountain.latitude,
          longitude: fm.mountain.longitude,
          difficulty: fm.mountain.difficulty_level
        },
        peak_month: fm.peak_month,
        days_until_peak: fm.days_until_peak,
        weather_forecast: weather_data,
        created_at: fm.created_at,
        updated_at: fm.updated_at
      }
    end
    
    render json: enhanced_data
  end
end
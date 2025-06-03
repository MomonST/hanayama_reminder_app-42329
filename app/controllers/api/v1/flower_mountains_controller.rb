class Api::V1::FlowerMountainsController < ApplicationController
  def index
    @flower_mountains = FlowerMountain.includes(:flower, :mountain)
    
    # フィルタリング
    @flower_mountains = @flower_mountains.joins(:mountain).where(mountains: { region: params[:region] }) if params[:region].present?
    @flower_mountains = @flower_mountains.where(peak_month: params[:month]) if params[:month].present?
    
    # 外部APIからの追加情報を取得
    enhanced_data = @flower_mountains.map do |fm|
      weather_data = WeatherApiService.get_bloom_forecast(fm.mountain.region)
      
      {
        id: fm.id,
        flower: {
          name: fm.flower.name,
          scientific_name: fm.flower.scientific_name
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
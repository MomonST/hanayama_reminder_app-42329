class Api::V1::FlowersController < ApplicationController
  def index
    @flowers = Flower.all
    
    # 植物識別APIからの追加情報
    enhanced_flowers = @flowers.map do |flower|
      {
        id: flower.id,
        name: flower.name,
        scientific_name: flower.scientific_name,
        bloom_period: "#{flower.bloom_start_month}月〜#{flower.bloom_end_month}月",
        description: flower.description,
        image_url: flower.image_url&.url
      }
    end
    
    render json: enhanced_flowers
  end
end
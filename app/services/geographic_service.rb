class GeographicService
  include HTTParty
  base_uri 'https://cyberjapandata.gsi.go.jp'

  # 国土地理院の標高API
  def self.get_elevation(latitude, longitude)
    response = get("/xyz/dem5a_png/15/#{longitude}/#{latitude}.txt")
    
    if response.success?
      response.body.to_f
    else
      nil
    end
  end

  # 登山道情報の取得
  def self.get_trail_info(mountain_name)
    # 登山道データの取得（実際のAPIエンドポイントに要変更）
    options = {
      query: {
        q: mountain_name,
        format: 'json'
      }
    }
    
    response = get('/api/trail_search', options)
    
    if response.success?
      parse_trail_data(response.parsed_response)
    else
      nil
    end
  end

  private

  def self.parse_trail_data(data)
    {
      trail_length: data['distance'],
      elevation_gain: data['elevation_gain'],
      difficulty: calculate_difficulty(data),
      estimated_time: data['estimated_time']
    }
  end

  def self.calculate_difficulty(trail_data)
    distance = trail_data['distance'] || 0
    elevation_gain = trail_data['elevation_gain'] || 0
    
    case
    when distance < 5 && elevation_gain < 500
      '初心者'
    when distance < 10 && elevation_gain < 1000
      '中級者'
    else
      '上級者'
    end
  end
end
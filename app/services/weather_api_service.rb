class WeatherApiService
  include HTTParty
  base_uri 'https://www.jma.go.jp/bosai'

  def self.get_bloom_forecast(region)
    # 気象庁の開花予想API
    response = get("/forecast/data/forecast/#{region_code(region)}.json")
    
    if response.success?
      parse_bloom_data(response.parsed_response)
    else
      Rails.logger.error "Weather API Error: #{response.code}"
      nil
    end
  end

  private

  def self.region_code(region)
    region_codes = {
      "北海道" => "016000",
      "東北" => "040000", 
      "関東" => "130000",
      "中部" => "230000",
      "近畿" => "270000",
      "中国" => "340000",
      "四国" => "370000",
      "九州" => "400000"
    }
    region_codes[region] || "130000"
  end

  def self.parse_bloom_data(data)
    # 開花予想データの解析処理
    {
      bloom_date: extract_bloom_date(data),
      temperature: extract_temperature(data),
      weather_condition: extract_weather(data)
    }
  end
end
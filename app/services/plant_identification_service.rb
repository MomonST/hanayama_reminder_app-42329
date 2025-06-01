class PlantIdentificationService
  include HTTParty
  base_uri 'https://my-api.plantnet.org/v1'

  def self.identify_plant(image_url)
    options = {
      body: {
        images: [image_url],
        modifiers: ["crops", "similar_images"],
        plant_details: ["common_names", "url"]
      }.to_json,
      headers: {
        'Content-Type' => 'application/json',
        'Api-Key' => ENV['PLANTNET_API_KEY']
      }
    }
    
    response = post('/identify', options)
    
    if response.success?
      parse_plant_data(response.parsed_response)
    else
      Rails.logger.error "PlantNet API Error: #{response.code}"
      nil
    end
  end

  private

  def self.parse_plant_data(data)
    return nil unless data['results']&.any?

    best_match = data['results'].first
    {
      scientific_name: best_match['species']['scientificNameWithoutAuthor'],
      common_names: best_match['species']['commonNames'],
      confidence: best_match['score'],
      family: best_match['species']['family']['scientificNameWithoutAuthor']
    }
  end
end
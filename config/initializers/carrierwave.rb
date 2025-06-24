CarrierWave.configure do |config|
  if Rails.env.production?
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region:                'ap-northeast-1' # 東京リージョンの例
    }
    config.fog_directory  = ENV['AWS_S3_BUCKET']
     
    config.fog_public     = true
    
    # ACLを無効→有効に変更
    config.fog_attributes = { cache_control: "public, max-age=86400" } # or 空でもOK
    config.storage        = :fog
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end

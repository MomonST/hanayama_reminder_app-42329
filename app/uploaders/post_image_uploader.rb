class PostImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # 保存先
  # storage :file ←これがあるとproductionでもローカル保存されるので、削除

  # 保存先のディレクトリ
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # リサイズ
  process resize_to_limit: [1200, 1200]

  # サムネイル
  version :thumb do
    process resize_to_fit: [300, 300]
  end

  # 許可する拡張子
  def extension_allowlist
    %w(jpg jpeg gif png)
  end
end
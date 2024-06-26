require 'carrierwave/orm/activerecord'

if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Configuration for Amazon S3
      provider: 'AWS',
      aws_access_key_id: ENV.fetch('S3_ACCESS_KEY', ''),
      aws_secret_access_key: ENV.fetch('S3_SECRET_KEY', '')
    }
    config.fog_directory = ENV.fetch('S3_BUCKET', '')
  end
end

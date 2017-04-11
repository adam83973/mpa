CarrierWave.configure do |config|
  if Rails.env.production?
    region = nil
  else
    region = 'us-east-2'
  end

  config.storage    = :aws
  config.aws_bucket = ENV['S3_BUCKET']
  config.aws_acl    = 'public-read'

  config.aws_credentials = {
    :access_key_id      => ENV['S3_KEY'],                # required
    :secret_access_key  => ENV['S3_SECRET'],             # required
    :region             => region
  }

  # The maximum period for authenticated_urls is only 7 days.
  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

  # Set custom options such as cache control to leverage browser caching
  config.aws_attributes = {
    expires: 1.week.from_now.httpdate,
    cache_control: 'max-age=604800'
  }
end

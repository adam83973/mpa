CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => 'AKIAIL65VEYP6WCPNOGQ',                        # required
    :aws_secret_access_key  => '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',                        # required
    :region                 => 'us-east-1',                  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'MPAAppImages'                     # required
end
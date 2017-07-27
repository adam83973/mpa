Infusionsoft.configure do |config|
  if Rails.env.production?
    config.api_url = 'jmrmath.infusionsoft.com'
    config.api_key = ENV['INFUSIONSOFT_KEY']
    config.api_logger = Logger.new("#{Rails.root}/log/infusionsoft_api.log")
  else
    config.api_url = 'po206.infusionsoft.com'
    config.api_key = ENV['INFUSIONSOFT_SANDBOX_KEY']
    config.api_logger = Logger.new("#{Rails.root}/log/infusionsoft_sandbox.log")
  end
end

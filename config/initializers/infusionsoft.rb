Infusionsoft.configure do |config|
  config.api_url = 'jmrmath.infusionsoft.com' # example infused.infusionsoft.com
  config.api_key = '7ffb0735b825e206bc4bf9e50198af6c'
  config.api_logger = Logger.new("#{Rails.root}/log/infusionsoft_api.log") # optional logger file
end
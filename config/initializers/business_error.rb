BusinessError::Config.tap do |config|
  config.default_http_status = 200
  config.formats[:old] = %i[ status msg http ]
end

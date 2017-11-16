class ZConfig
  extend ZConfigurable::Init
  default({
      hello: '*** Zero',
      world: ' Rails ***'
  })

  # class << self
  # 已经能够自动扫描
  #   def swagger
  #     Swagger::Docs::Config
  #   end
  # end

end

Z = ZConfig

# TODO(FIX): 这个配置必须被写在所有配置之前，无论是否同一个配置类 ...
#            可能是块之间的问题
# SingleConfig.configure do |c|
#   c.foo = 'single config'
# end

Z.processor do |c|
  c.foo = 'bar'
  c.base_error_class = ApiError
  # c.base_mapper_class = ApiErrorMapper
end

Z.whatever do |c|
  c.foo = 'foo'
end

puts Z.processor.hello << Z.processor.world
# puts Z.processor.foo
# puts Z.whatever.foo
# puts SingleConfig.foo
# puts Z.processor.base_error_class
# puts Z.processor.bar  # => nil
# puts Z.processor.bar! # => raises KeyError: key not found: :bar
# puts Z.processor # => { .. }

# puts Z.open_api.apis
# puts Z.smartSMS

# module ZeroLANG
#   module Config
#     def self.coming_soon
#       '*** zzzzzzzero-lang is coming soonnn! ***'
#     end
#   end
#
  # # def self.config
  # #   '*** zzzzzzzero-lang is coming soonnn! ***'
  # # end
# end
# puts Z.zeroLANG.coming_soon # ZConfig.zeroLANG => ZeroLANG::Config
# puts ZConfig.zeroLANG           # ZConfig.zeroLANG => ZeroLANG.config
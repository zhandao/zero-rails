class ApiDoc < Object
  include OpenApi::DSL
  include AutoGenDoc
  include Generators::Jbuilder::DSL if Rails.env.development?
  include Generators::ApiDocSupport::DSL if Rails.env.development?
  unless Rails.env.development?
    def self.api action, summary = '', http: nil, builder: nil, skip: [ ], use: [ ], &block
      super(action, summary, http: http, skip: skip, use: use, &block)
    end
  end

  class << self
    def undo_dry
      @zro_dry_blocks = nil
    end

    def id
      [ :id ]
    end

    def none
      [ :none ]
    end
  end
end

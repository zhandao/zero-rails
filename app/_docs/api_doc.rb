class ApiDoc < Object
  include OpenApi::DSL
  include AutoGenDoc
  include Generators::Jbuilder::DSL
  include Generators::ApiDocSupport::DSL

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

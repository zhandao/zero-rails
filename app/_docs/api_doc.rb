class ApiDoc < Object
  include OpenApi::DSL
  include AutoGenDoc

  # TODO: generate controller.rb, error.rb, rspec_doc, jbuilder

  class << self
    def skip *params
      @skip = params
    end

    def use *params
      @use = params
    end

    def undo_dry
      @_apis_blocks = nil
    end

    def id
      [ :id ]
    end

    def none
      [ :none ]
    end

    def token
      [ 'Token' ]
    end

    def id_and_token
      token.dup << :id
    end
  end
end

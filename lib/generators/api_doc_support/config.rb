module Generators::ApiDocSupport
  module Config
    cattr_accessor :enable do
      true
    end

    cattr_accessor :overwrite do
      false
    end
  end
end

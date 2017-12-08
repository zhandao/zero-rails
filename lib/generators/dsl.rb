module Generators
  module DSL
    def v(version)
      self.version = "_v#{version}"
    end

    alias version v
  end
end

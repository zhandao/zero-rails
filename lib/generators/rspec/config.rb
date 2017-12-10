module Generators::Rspec
  module Config
    cattr_accessor :params do
      { }
    end

    cattr_accessor :it_templates do
      { }
    end

    cattr_accessor :desc_templates do
      { }
    end

    cattr_accessor :overwrite do
      false
    end
  end
end

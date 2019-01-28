class Api::Schemas
  class << self
    def get(key)
      normal[key] || normal["#{key}!".to_sym] || normal[key.to_s.tr('!', '').to_sym]
    end

    def slice(*keys)
      keys.map { |key| [ key, get(key) ] }.to_h
    end
  end
end

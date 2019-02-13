# frozen_string_literal: true

class Api::Schemas
  class << self
    def get(part = nil, key)
      part = part ? send(part) : normal
      part[key] || part["#{key}!".to_sym] || part[key.to_s.tr('!', '').to_sym]
    end

    def slice(*keys, with: { }, of: nil)
      keys.map { |key| [ key, get(of, key).merge(with) ] }.to_h
    end
  end
end

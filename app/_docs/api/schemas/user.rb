# frozen_string_literal: true

class Api::Schemas::User < Api::Schemas
  def self.normal
    {
        id: { type: Integer, example: 2 },
    }
  end
end

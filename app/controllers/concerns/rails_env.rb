# frozen_string_literal: true

module RailsEnv
  extend ActiveSupport::Concern

  included do
    def dev?
      Rails.env.development?
    end

    def dev_or_test?
      # return false
      Rails.env.development? || Rails.env.test?
    end

    def deployed?
      Rails.env.staging? || Rails.env.production?
    end
  end
end

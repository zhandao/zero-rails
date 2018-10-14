module Rescuer
  extend ActiveSupport::Concern

  included do
    def self.error_map(mapping)
      mapping.each do |biz_error_name, error|
        rescue_from error do |_|
          log_and_render Error::Api.send(biz_error_name).info
        end
      end
    end
  end
end

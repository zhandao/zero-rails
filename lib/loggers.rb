# frozen_string_literal: true

class Loggers
  cattr_accessor :loggers

  class << self
    def register(name, path = nil, format: :normal)
      name = name.to_sym
      path = nil if Rails.env.test? && path&.match?('/data/logs') # for ci
      return puts "Logger named #{name} has exists".red if loggers&.key?(name.to_sym)

      (self.loggers ||= { })[name] = ::Logger.new(path || "log/#{name}.log")
      if format == :json
        loggers[name].formatter = proc do |severity, datetime, prog_name, data|
          info = {
              time: datetime.iso8601,
              level: severity,
              # prog: prog_name
          }
          info.merge!(data.is_a?(Hash) ? data : { msg: data })

          info.to_json.concat("\n")
        end
      end

      define_singleton_method(name) { loggers[name] }
    end
  end
end

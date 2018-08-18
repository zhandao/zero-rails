class Loggers
  cattr_accessor :loggers

  class << self
    def register(name, path = nil)
      (self.loggers ||= { })[name.to_sym] = ::Logger.new(path || "log/#{name}.log")

      define_singleton_method(name) { loggers[name.to_sym] }
    end
  end
end

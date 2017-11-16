module Zero::Log
  ZLogger = Rails.logger

  # TODO: unfinished, no idea to log business error now.
  def log_error msg
    msg = { level: 'ERROR' }
              .merge msg.is_a?(StandardError) ? msg.info : { msg: msg }
    ZLogger.error msg
  end
end

__END__

# Logging severity.
  module Severity
    # Low-level information, mostly for developers.
    DEBUG = 0
    # Generic (useful) information about system operation.
    INFO = 1
    # A warning.
    WARN = 2
    # A handleable error condition.
    ERROR = 3
    # An unhandleable error that results in a program crash.
    FATAL = 4
    # An unknown message that should always be logged.
    UNKNOWN = 5
  end


module BusinessError
  class ZError < StandardError
    attr_accessor :name, :message, :code, :http_status
    def initialize(name, message, code, http_status = 200)
      message = name if message.blank?
      @name, @message, @code, @http_status, @output = name, message, code, http_status
    end

    def info
      @info ||= { code: @code, msg: @message, http_status: @http_status }
    end

    def output(content)
      @info = info.merge output: content
      raise self
    end

    alias out    output
    alias render output

    def and(addtion_content)
      @info = info.merge output: info.merge(addtion_content).except(:http_status)
      raise self
    end

    alias set     and
    alias addput  and
    alias addout  and
    alias and_out and

    def message; info.to_s end
  end
end

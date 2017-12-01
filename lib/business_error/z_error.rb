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

    alias out output

    def and(addtion_content)
      @info = info.merge output: info.merge(addtion_content)
      raise self
    end

    alias addput and
    alias addout and
    alias and_out and

    def message; info.to_s end
  end

  attr_accessor :errors

  def mattr_reader name, message, code = nil, http: 200
    set_for name.to_s.split('_').first.to_sym, @code if @set_for_by_prefix
    (code = @code) and code_op if code.nil?
    http = @http_status if @http_status.present?
    message = name.to_s.humanize.downcase if message == ''

    define_singleton_method name do
      ZError.new(name, message, code, http)
    end

    define_singleton_method "#{name}!" do
      raise ZError.new(name, message, code, http)
      # TODO: raise ZError, name, message, code
    end

    if @for.present?
      # private_class_method name
      ((@errors ||= { })[@for] ||= []) << name
    else
      ((@errors ||= { })[:private] ||= []) << name
    end
  end

  alias_method :define, :mattr_reader

  def def_errors mapping
    mapping.each { |(name, msg)| mattr_reader name, msg }
  end

  # 目的是在 autogen doc resp 时指定特定的 action
  def set_for who, code_start_at = nil, code_op = :inc
    @for = who
    code code_start_at, code_op
  end

  def set_global option, code_start_at = nil, code_op = :inc
    if option == :prefix
      @set_for_by_prefix = true
    end
    code code_start_at, code_op
  end

  def set_for_pub
    @for = :_public
  end

  # TODO: 可以对 private 的数组指定对 action 移除
  def unset
    @set_for_by_prefix = nil
    @for = nil
  end

  def code code, op = :inc
    @code = code
    @code_op = op
  end

  def code_op
    @code = @code_op == :inc ? @code + 1 : @code - 1
  end

  def http status_code
    @http_status = status_code
  end

  def unset_http
    @http_status = nil
  end

  def inherited(subclass)
    subclass.errors = errors.slice :_public
  end
end

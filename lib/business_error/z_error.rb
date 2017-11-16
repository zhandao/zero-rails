module BusinessError

  class ZError < StandardError
    attr_accessor :name, :message, :code
    def initialize(name, message, code)
      message = name if message.blank?
      @name, @message, @code = name, message, code
    end

    def info
      { code: @code, msg: @message}
    end
  end

  attr_accessor :errors

  def mattr_reader name, message, code = nil
    set_for name.to_s.split('_').first.to_sym, @code if @set_for_by_prefix
    code = @code and code_op if code.nil?
    define_singleton_method name do |watch_info = nil|
      message = name.to_s.humanize.downcase if message == ''
      if watch_info == :info
        # ZError.new(name, message, code).info
        { code: code, msg: message }
      else
        raise ZError.new(name, message, code)
        # raise ZError, name, message, code
      end
    end

    if @for.present?
      # private_class_method name
      ((@errors ||= { })[@for] ||= []) << name
    else
      ((@errors ||= { })[:private] ||= []) << name
    end
  end
  alias_method :define, :mattr_reader

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

  def inherited(subclass)
    subclass.errors = errors.slice :_public
  end
end

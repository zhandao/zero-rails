module Generators
  module Helpers
    def rescue_no_method_run
      yield
    rescue NoMethodError => e
      raise NoMethodError, e.message unless e.message.match?('no superclass method')
    end

    def add_ind_to(mtline_str, space_times = 1) # indentation
      return 'XXX' if mtline_str.blank?
      mtline_str.gsub("\n", "\n#{'  ' * space_times}")[0..-3]  # 缩进
                .gsub(/ *\n/, "\n")         # 去除带空行的空格
                .gsub(/end\n\n\n/, "end\n") # 去掉多余的多空行
                .gsub(/ *XXX\n/, '')        # 去掉 XXX 标记的行
    end

    def pr(obj, full = nil)
      if obj.is_a? Hash
        obj = obj.to_s[1..-2].sub(':', '').gsub(', :', ', ').gsub('=>', ': ').gsub('\"', '"').tr(?", ?')
        full ? "{ #{obj} }" : obj
      elsif obj.is_a?(String)
        "'#{obj}'"
      elsif obj.is_a? Regexp
        obj.inspect#.delete('/')
      elsif obj.is_a?(Array) && (is_str_arr?(obj) || is_sym_arr?(obj))
        is_sym_arr?(obj) ? obj.to_s.gsub(', :', ' ').sub('[:', '%i[ ').sub(']', ' ]') :
            obj.to_s.gsub(/\"/, ' ').gsub(', ', '').sub('[', '%w[')
      elsif obj.is_a? Symbol
        ":#{obj}"
      else
        obj
      end
    end

    def is_str_arr?(arr)
      arr.each { |item| return false unless item.is_a?(String) }
      true
    end

    def is_sym_arr?(arr)
      arr.each { |item| return false unless item.is_a?(Symbol) }
      true
    end

    def key_alias(hash, mapping)
      mapping.each do |givens, old|
        Array(givens).each do |given|
          hash[old] ||= hash[given] if hash.key?(given)
          hash.delete(given) unless given.match?('unique')
        end
      end
      hash
    end

    def write type, content, to:
      File.open(to, 'w') { |file| file.write content }
      puts "[ZERO] #{type} file has been #{File.exist?(to) ? 'OVER-WRITTEN' : 'generated'}: #{to}"
    end
  end
end

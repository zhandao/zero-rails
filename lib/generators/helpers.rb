module Generators
  module Helpers
    def rescue_no_run
      yield
    rescue NoMethodError => e
      pp "[ERROR] #{e.message}" unless e.message.match?('no superclass method')
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
      elsif obj.is_a? String
        "'#{obj}'"
      else
        obj
      end
    end
  end
end

module RspecGenerator
  module CommonHelpers
    def self.included(base)
      base.class_eval do
        attr_accessor :content_stack ,:path
      end
    end

    def run
      Dir['./app/**/*_spdoc.rb'].each { |file| require file }
      descendants.each do |spdoc|
        *dir_path, file_name = spdoc.path.split('/')
        dir_path = "spec/#{dir_path.join('/')}"
        FileUtils.mkdir_p dir_path
        file_path = "#{dir_path}/#{file_name}_spec.rb"

        # unless File::exists?(file_path)
        if true
          File.open(file_path, 'w') { |file| file.write spdoc.whole_file }
          puts "[ZRO] Spec file has been generated: #{file_path}"
        end
      end
    end

    def set_path(path)
      self.path = path
    end

    # def content_stack_last block, template_result
    #   sub_content = _instance_eval(block) if block
    #   content_stack.last << template_result
    #   content_stack.last << "\n"
    # end

    def _instance_eval(block)
      content_stack.push ''
      instance_eval &block
      content_stack.pop
    end

    def add_ind_to(mtline_str) # indentation
      return 'TODO' if mtline_str.nil?
      mtline_str.gsub("\n", "\n  ")[0..-3]  # 缩进
                .gsub(/ *\n/, "\n")         # 去除带空行的空格
                .gsub(/end\n\n\n/, "end\n") # 去掉多余的多空行
                .gsub(/ *TODO\n/, '')       # 去掉 TO DO 标记的行
    end

    def pr(hash)
      hash.to_s[1..-2].sub(':', '').gsub(', :', ', ').gsub('=>', ': ').gsub('\"', '"').tr(?", ?')
    end
  end
end

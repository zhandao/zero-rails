module RspecGenerator
  module CommonHelpers
    def self.included(base)
      base.class_eval do
        attr_accessor :content_stack, :path, :each
      end
    end

    def inherited(base)
      super
      base.class_eval do
        self.path = name.sub('Spdoc', '').underscore.gsub('::', '/') unless path
        self.content_stack = [ '' ]
        self.each = { describe: '', conetxt: '' }
      end
    end

    def run
      rescue_no_run { super() }
      Dir['./app/**/*_spdoc.rb'].each { |file| require file }
      descendants.each do |spdoc|
        *dir_path, file_name = spdoc.path.split('/')
        dir_path = "spec/#{dir_path.join('/')}"
        FileUtils.mkdir_p dir_path
        file_path = "#{dir_path}/#{file_name}_spec.rb"

        # if Config.overwrite_files || !File::exist?(file_path)
        if true
          File.open(file_path, 'w') { |file| file.write spdoc.whole_file.sub("\n\n\nend\n", "\nend\n") }
          puts "[Zero] Spec file has been generated: #{file_path}"
        end
      end
    end

    def rescue_no_run
      yield
    rescue NoMethodError => e
      pp "[ERROR] #{e.message}" unless e.message.match?('no superclass method')
    end

    def set_path(path)
      self.path = "#{path}/#{name.sub('Spdoc', '').downcase}"
    end

    # def content_stack_last block, template_result
    #   sub_content = _instance_eval(block) if block
    #   content_stack.last << template_result
    #   content_stack.last << "\n"
    # end

    def _instance_eval(block)
      self.each = { describe: '', context: '' }
      content_stack.push ''
      instance_eval(&block)
      content_stack.pop
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

    # process desc by using template
    def d desc
      return desc unless desc.is_a? Symbol
      RspecGenerator::Config.desc_templates[desc] || desc
    end

    def _error_info(error_name, code_or_msg = :code)
      return error_name unless error_name.is_a?(Symbol) && !error_name.match?(' ') && !error_name.match?('\(')

      error_class_name = path.split('/').last.camelize.concat('Error')
      error_class = Object.const_get(error_class_name) rescue ApiError
      error_class.send(error_name, :info)[code_or_msg]
    end

    def _does_what(does_what, err_msg)
      desc = _error_info(err_msg, :msg)
      # 如果 error msg 存在，则输出，且如果 desc 空，则不加逗号
      unless desc == err_msg
        "#{does_what.blank? ? '' : does_what + ', '}#{desc}"
      else
        does_what
      end
    end

    def _biz desc = '', template: nil, &block
      sub_content = _instance_eval(block) if block_given?
      content_stack.last << <<~BIZ
        describe '#{d(desc)}' do
          #{add_ind_to each[:describe]}
          #{add_ind_to sub_content}
        end
      BIZ
      content_stack.last << "\n"
    end
  end
end

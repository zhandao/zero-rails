module Generators::Rspec
  module Helpers
    include Generators::Helpers

    def self.included(base)
      base.class_eval do
        attr_accessor :content_stack, :path, :each, :version
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
      rescue_no_method_run { super() }
      Dir['./app/**/*_spdoc.rb'].each { |file| require file }
      descendants.each do |spdoc|
        *dir_path, file_name = spdoc.path.split('/')
        dir_path = "spec/#{dir_path.join('/')}"
        FileUtils.mkdir_p dir_path
        file_path = "#{dir_path}/#{file_name}#{spdoc.version}_spec.rb"

        if Generators::Rspec::Config.overwrite || !File::exist?(file_path)
        # if true
          write :Spec, spdoc.whole_file.sub("\n\n\nend\n", "\nend\n"), to: file_path
        end
      end
    end

    def set_path(path)
      self.path = "#{path}/#{name.sub('Spdoc', '').downcase}"
    end

    def _instance_eval(block)
      self.each = { describe: '', context: '' }
      content_stack.push ''
      instance_eval(&block)
      content_stack.pop
    end

    # process desc by using template
    def desc_temp(desc)
      return desc unless desc.is_a? Symbol
      Generators::Rspec::Config.desc_templates[desc] || desc
    end

    def _error_info(error_name, code_or_msg = :code)
      return error_name unless error_name.is_a?(Symbol) && !error_name.match?(' ') && !error_name.match?('\(')

      error_class_name = path.split('/').last.camelize.concat('Error')
      error_class = Object.const_get(error_class_name) rescue ApiError
      error_class.send(error_name).info[code_or_msg]
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
        describe '#{desc_temp(desc)}' do
          #{add_ind_to each[:describe]}
          #{add_ind_to sub_content}
        end
      BIZ
      content_stack.last << "\n"
    end
  end
end

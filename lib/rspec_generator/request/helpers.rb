module RspecGenerator
  module Request
    module Helpers
      def _request_params
        if (examples = describe_doc.doc[:examples]).present?
          self.let_param_name = examples.first.keys[0]
          pr(Hash[ examples.first[let_param_name][:value].map { |k, v| [k.to_sym, v] } ])
        else
          self.let_param_name = 'params'
          params_doc = describe_doc.doc['parameters']
          params_keys = params_doc.map { |p| p['name'] }
          pr Hash[ params_keys.map do |key|
            value = key.to_sym.in?([]) ? '' : params_doc[params_keys.index(key)]['schema']['type']
            [key.to_sym, value]
          end ]
        end
      end

      def _biz desc = '', template: nil, &block
        sub_content = _instance_eval(block) if block_given?
        content_stack.last << <<~BIZ
          describe '#{desc}' do
            #{add_ind_to sub_content}
          end
        BIZ
        content_stack.last << "\n"
      end

      def _request_by(merge = nil, params = { })
        params = merge if merge.is_a? Hash
        params = merge == :merge ? ", #{let_param_name}.merge(#{pr(params)})" : ", #{pr(params)}" if params.present?
        url = describe_doc.path.match?('{') ? %{"#{describe_doc.path.gsub('{', '#{')}"} : "'#{describe_doc.path}'"
        %{#{describe_doc.verb} #{url}#{params if params.present?}}
      end

      def _expect(who, whos, what, not_what)
        return 'TODO  ' if who.nil? && whos.nil?

        if who.is_a? Hash
          who.map do |obj_name, exp_value|
            exp_value = _error_info(exp_value)
            exp_value = exp_value.is_a?(Symbol) && exp_value.match?(' ') ? exp_value.to_s : "eq #{exp_value}"
            "expect(#{obj_name.to_s.delete('!')}).#{obj_name['!'] ? 'not_to' : 'to'} #{exp_value}"
          end
        elsif whos.is_a? Hash
          whos.map do |obj_name, exp_value|
            exp_value = _error_info(exp_value)
            exp_value = exp_value.is_a?(Symbol) && exp_value.match?(' ') ? exp_value.to_s : "eq #{exp_value}"
            "expect(json['#{obj_name.to_s.delete('!')}']).#{obj_name['!'] ? 'not_to' : 'to'} #{exp_value}"
          end
        else
          obj = who ? who : "json['#{whos}']"
          [ what, not_what ].map do |w|
            next if w.nil?
            w = _error_info(w)
            exp_str = w.is_a?(Symbol) && w.match?(' ') ? "to #{w}" : "to eq #{w}"
            exp_str = "not_#{exp_str}" if not_what
            "expect(#{obj}).#{exp_str}"
          end.compact
        end.join("\n") << '  '
      end

      def _error_info(error_name, code_or_msg = :code)
        return error_name unless error_name.is_a?(Symbol) && !error_name.match?(' ')

        error_class_name = ctrl_path.split('/').last.camelize.concat('Error')
        error_class = Object.const_get(error_class_name) rescue ApiError
        error_class.send(error_name, :info)[code_or_msg]
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
end

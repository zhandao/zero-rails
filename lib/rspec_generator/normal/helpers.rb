module RspecGenerator
  module Normal
    module Helpers
      def _biz desc = '', template: nil, &block
        sub_content = _instance_eval(block) if block_given?
        content_stack.last << <<~BIZ
          describe '#{desc}' do
            #{add_ind_to sub_content}
          end
        BIZ
        content_stack.last << "\n"
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

      def let
        #
      end

      def create
        #
      end
    end
  end
end

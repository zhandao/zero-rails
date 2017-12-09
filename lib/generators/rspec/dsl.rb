module Generators::Rspec
  module DSL
    include Generators::DSL

    def let name, what, behave = nil
      result = "let(:#{name}) { #{pr(what, :full)} }\n"
      content_stack.last << "#{result}\n" and return if behave.nil?
      behave == :each_context ? each[:context] << result : each[:describe] << result
    end

    def create name, each: nil, **attrs
      addition = attrs.present? ? ", #{pr(attrs)}" : ''
      result = "let(:#{name}) { create(:#{name}#{addition}) }\n"
      content_stack.last << "#{result}\n" and return if each.nil?
      each == :context ? each[:context] << result : each[:describe] << result
    end

    def subject what, behave = nil
      result = "subject { #{pr(what, :full)} }\n"
      content_stack.last << "#{result}\n" and return if behave.nil?
      behave == :each_context ? each[:context] << result : each[:describe] << result
    end

    def is(what); what; end

    # context when TODO: name
    def wh what = '', &block
      context "when #{what}", &block
    end

    def biz_scenario desc = '', template: nil, &block
      _biz desc, template: template, &block
    end

    alias_method :biz, :biz_scenario

    def context when_what = '', &block
      sub_content = block_given? ? _instance_eval(block) : default_context
      content_stack.last << <<~CONTEXT
        context '#{desc_temp(when_what)}' do
          #{add_ind_to each[:context]}
          #{add_ind_to sub_content}
        end
      CONTEXT
      content_stack.last << "\n"
    end

    def right &block
      context :right, &block
    end

    def wrong &block
      context :wrong, &block
    end
  end
end

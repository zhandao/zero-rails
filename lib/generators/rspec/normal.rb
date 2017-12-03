module Generators::Rspec
  module Normal
    def self.included(base)
      base.extend ClassMethods
    end

    # What is the meaning of normal spdoc?
    # Doesn't it seem to generate a lot of code?
    #   1. Allow you to first consider the test description that needs to be achieved.
    #   2. Splitting the work of test code also helps to reduce the pain.
    #   3. Gathering the description of the test code helps to quickly understand the test.
    module ClassMethods
      include Generators::Rspec::Helpers
      include Generators::Rspec::DSL
      include Generators::Rspec::Normal::Helpers

      def describe method = nil, add_desc = nil, desc: nil, template: nil, &block
        _biz add_desc, template: template, &block if method.nil?

        desc = desc_temp(desc) || method.is_a?(Symbol) ? "##{method}" : ".#{method}"
        desc << ", #{add_desc}" if add_desc
        sub_content = _instance_eval(block) if block_given?

        content_stack.last << <<~DESCRIBE
          describe '#{desc}' do
            #{add_ind_to each[:describe]}
            #{add_ind_to sub_content}
          end
        DESCRIBE
        content_stack.last << "\n"
      end

      # TODO: auto gen desc
      def it does_what = nil, when: nil, then: nil, its: nil, then_its: nil,
             is_expected: nil, isnt_expected: nil, should: nil, shouldnt: nil, &block
        return oneline_it if does_what.nil?
        if (templates = Generators::Rspec::Config.it_templates).key?(does_what)
          content_stack.last << "it { #{templates[does_what]} }\n" and return
        end

        sub_content = _instance_eval(block) if block_given?
        what = is_expected || should
        not_what = isnt_expected || shouldnt
        expects = _expect(binding.local_variable_get(:then), its || then_its, what, not_what)
        content_stack.last << <<~IT
          it '#{_does_what(desc_temp(does_what), what || not_what)}' do
            #{add_ind_to expects}
            #{add_ind_to sub_content}
          end
        IT
        content_stack.last << "\n"
      end

      def oneline_it
        content_stack.last << <<~IT
          subject { '' }
          it { is_expected.to eq '' }
        IT
        content_stack.last << "\n"
      end
    end
  end
end

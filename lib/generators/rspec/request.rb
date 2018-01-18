module Generators::Rspec
  module Request
    def self.included(base)
      base.class_eval do
        require 'params_processor/doc_converter'

        cattr_reader :apis do
          ::ParamsProcessor::DocConverter.docs ||= ::ParamsProcessor::DocConverter.new OpenApi.docs
        end
      end
      base.extend ClassMethods
    end

    module ClassMethods
      include Generators::Rspec::Helpers
      include Generators::Rspec::DSL
      include Generators::Rspec::Request::Helpers

      attr_accessor :doc, :describe_doc, :let_param_name
      alias_attribute :ctrl_path, :path

      def describe action = nil, add_desc = nil, desc: nil, template: nil, &block
        _biz add_desc, template: template, &block if action.nil?

        path, http_verb = ::OpenApi::Generator.find_path_httpverb_by(ctrl_path, action)
        action_doc = doc[path][http_verb]
        self.describe_doc = ActiveSupport::OrderedOptions.new.merge(
            action: action, path: path, verb: http_verb, doc: action_doc
        )
        request_params = _request_params

        summary = action_doc['summary'].sub('GET ', 'get ').sub('PATCH ', '')
                      .sub('POST', 'post').sub('DELETE', 'delete') if action_doc['summary']
        desc = desc_temp(desc) || "#{http_verb.upcase} #{path} to ##{action}" \
                       ", #{add_desc || summary || action_doc['description']}"
        sub_content = _instance_eval(block) if block_given?

        content_stack.last << <<~DESCRIBE
          describe '#{desc}' do
            let(:#{let_param_name}) { { #{request_params} } }
            #{add_ind_to each[:describe]}

            #{add_ind_to sub_content}
          end
        DESCRIBE
        content_stack.last << "\n"
      end

      def request_by(merge = nil, params = { })
        content_stack.last << <<~REQ
          before { #{_request_by(merge, params)} }
        REQ
        content_stack.last << "\n"
      end
      alias_method :request, :request_by

      def it does_what = nil, when: nil, then: nil, its: nil, then_its: nil,
             is_expected: nil, isnt_expected: nil, should: nil, shouldnt: nil, **params, &block
        return oneline_it(binding.local_variable_get(:when), params) if does_what.nil?
        if (templates = Generators::Rspec::Config.it_templates).key?(does_what)
          content_stack.last << "it { #{templates[does_what]} }\n" and return
        end

        sub_content = _instance_eval(block) if block_given?
        what = is_expected || should
        not_what = isnt_expected || shouldnt
        expects = _expect(binding.local_variable_get(:then), its || then_its, what, not_what)
        content_stack.last << <<~IT
          it '#{_does_what(desc_temp(does_what), what || not_what)}' do
            #{_request_by(binding.local_variable_get(:when), params)}
            #{add_ind_to expects}
            #{add_ind_to sub_content}
          end
        IT
        content_stack.last << "\n"
      end

      def oneline_it(merge = nil, params = { })
        content_stack.last << <<~IT
          before { #{_request_by(merge, params)} }
          it { expect(json['code']).to eq 200 }
        IT
        # it { is_expected.to include('code' => 200) }
        content_stack.last << "\n"
      end

      # TODO: remove
      def inherited(base)
        super
        base.class_eval do
          self.doc = apis[OpenApi.routes_index[ctrl_path]]['paths']
        end
      end
    end
  end
end

require 'open_api/generator'

module AutoGenDoc
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def inherited(subclass)
      super
      subclass.class_eval do
        break unless name.match?(/Controller|Doc/)
        route_base name.sub('Doc', '').underscore.gsub('::', '/') if name.match?(/Doc/)
        open_api_dry
      end
    end

    private

    def open_api_dry
      route_base = try(:controller_path) || instance_variable_get('@route_base')
      ::OpenApi::Generator.get_actions_by_route_base(route_base)&.each do |action|
        api_dry action do
          # Common :index parameters
          if action == 'index'
            query :created_from, DateTime, desc: 'YY-MM-DD (HH:MM:SS, optional)', as: :start
            query :created_to,   DateTime, desc: 'YY-MM-DD (HH:MM:SS, optional)', as: :end
            query :search_value, String
            query :page, Integer, range: { ge: 1 }, dft: 1
            query :rows, Integer, desc: 'per page, number of result', range: { ge: 1 }, dft: 10
          end

          # Common :show parameters
          if action == 'show'
            path! :id, Integer
          end

          # Common :destroy parameters
          if action == 'destroy'
            path! :id, Integer
          end

          # Common :update parameters
          if action == 'update'
            path! :id, Integer
          end

          ### Common responses
          # OAS require at least one response on each api.
          # default_response 'default response', :json
          model = Object.const_get(action_path.split('#').first.split('/').last[0..-2].camelize) rescue nil
          type = action.in?(%w[ index show ]) ? Array[load_schema(model)] : String
          response 200, 'success', :json, data: {
              code:      { type: Integer, dft: 200 },
              msg:       { type: String,  dft: 'success' },
              total:     { type: Integer },
              timestamp: { type: Integer },
              language:  { type: String, dft: 'Ruby' },
              data:      { type: type }
          }

          # automatically generate responses based on the agreed error class.
          # api/v1/examples#index => ExamplesError
          error_class_name = action_path.split('#').first.split('/').last.camelize.concat('Error')
          error_class = Object.const_get(error_class_name) rescue ApiError
          cur_api_errs = error_class.errors.values_at(action.to_sym, :private, :_public).flatten.compact.uniq
          cur_api_errs.each do |error|
            info = error_class.send(error).info
            response info[:code], info[:msg]
          end
        end
      end
    end
  end
end

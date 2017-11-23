require 'params_processor/doc_converter'

class RequestSpdoc
  cattr_reader :apis do
    ::ParamsProcessor::DocConverter.new OpenApi.docs
  end

  include RspecGenerator::Request
end

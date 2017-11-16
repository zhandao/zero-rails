require 'params_processor/doc_converter'

class BaseSpdoc
  cattr_reader :apis do
    ::ParamsProcessor::DocConverter.new $open_apis
  end

  include RspecGenerator::Request
end

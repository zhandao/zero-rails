require 'params_processor/doc_converter' if Rails.env.development?

class RequestSpecDoc
  include Generators::Rspec::Request if Rails.env.development?
end

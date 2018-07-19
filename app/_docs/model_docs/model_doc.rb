class ModelDoc
  include Generators::ModelDocSupport::DSL if Rails.env.development?
end

class Api::V1::BaseController < Api::ApiController
  include Export

  # it must: :not_null
  # it must!: :not_null
  # it must_be: :not_null
  # it is?: :not_null
  #
  # subject 'ikkiuchi'
  # pp 'hello world!' if it is?: :not_null
  # pp 'hello world!' if it.must! :not_null
  logic :not_null do !nil? end
end

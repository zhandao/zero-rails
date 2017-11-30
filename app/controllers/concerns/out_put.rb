module OutPut
  extend ActiveSupport::Concern

  private

  def ren(json = { })
    json  = ren_processed json
    total = json[:total]
    data  = json[:data]
    total = if    json[:msg].present?; 0
            elsif data.is_a?(Array);   data.size
            elsif data.present?;       1
            end if total.nil?

    render :json => {
        code:      json[:code]  || 200,
        msg:       json[:msg]   || 'success',
        total:     total        || 0,
        timestamp: Time.current.to_i,
        language:  'Ruby',
        data:      data.nil? ? '' : data
    }, :status => json[:http] || 200
  end
  alias out ren
  alias output ren
  alias response_ok ren

  def ren_processed(json)
    return json.info if json.is_a? StandardError
    json.is_a?(Hash) && (json.keys & %i[ data msg ]).any? ? json : { data: json }
  end
end

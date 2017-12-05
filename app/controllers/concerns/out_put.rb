module OutPut
  private

  def ren(json = { })
    json  = ren_processed json
    return render json: json[:output], status: json[:http] if json[:output].present?

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
    }, :status => json[:http_status] || 200
  end
  alias out ren
  alias output ren
  alias response_ok ren

  def ren_processed(json)
    return json.info if json.is_a? StandardError
    json.is_a?(Hash) && (json.keys & %i[ data msg ]).any? ? json : { data: json }
  end
end

__END__

curl -s https://www.iana.org/assignments/http-status-codes/http-status-codes-1.csv | \
  ruby -ne 'm = /^(\d{3}),(?!Unassigned|\(Unused\))([^,]+)/.match($_) and \
    puts "#{m[1]} => \x27#{m[2].strip}\x27,"'

100 => 'Continue',
101 => 'Switching Protocols',
102 => 'Processing',
103 => 'Early Hints',
200 => 'OK',
201 => 'Created',
202 => 'Accepted',
203 => 'Non-Authoritative Information',
204 => 'No Content',
205 => 'Reset Content',
206 => 'Partial Content',
207 => 'Multi-Status',
208 => 'Already Reported',
226 => 'IM Used',
300 => 'Multiple Choices',
301 => 'Moved Permanently',
302 => 'Found',
303 => 'See Other',
304 => 'Not Modified',
305 => 'Use Proxy',
307 => 'Temporary Redirect',
308 => 'Permanent Redirect',
400 => 'Bad Request',
401 => 'Unauthorized',
402 => 'Payment Required',
403 => 'Forbidden',
404 => 'Not Found',
405 => 'Method Not Allowed',
406 => 'Not Acceptable',
407 => 'Proxy Authentication Required',
408 => 'Request Timeout',
409 => 'Conflict',
410 => 'Gone',
411 => 'Length Required',
412 => 'Precondition Failed',
413 => 'Payload Too Large',
414 => 'URI Too Long',
415 => 'Unsupported Media Type',
416 => 'Range Not Satisfiable',
417 => 'Expectation Failed',
421 => 'Misdirected Request',
422 => 'Unprocessable Entity',
423 => 'Locked',
424 => 'Failed Dependency',
426 => 'Upgrade Required',
428 => 'Precondition Required',
429 => 'Too Many Requests',
431 => 'Request Header Fields Too Large',
451 => 'Unavailable For Legal Reasons',
500 => 'Internal Server Error',
501 => 'Not Implemented',
502 => 'Bad Gateway',
503 => 'Service Unavailable',
504 => 'Gateway Timeout',
505 => 'HTTP Version Not Supported',
506 => 'Variant Also Negotiates',
507 => 'Insufficient Storage',
508 => 'Loop Detected',
510 => 'Not Extended',
511 => 'Network Authentication Required',

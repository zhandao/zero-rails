json.code      @_code || 200
json.msg       @_msg  || ''
json.timestamp Time.current.to_i
json.language  'Ruby'
json.total     total
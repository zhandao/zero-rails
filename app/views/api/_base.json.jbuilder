json.result do
  json.code @view[:code] || 0
  json.msg  @view[:msg]  || 'success'
end

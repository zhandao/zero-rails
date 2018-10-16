json.partial! 'api/base'

json.cache! ['nested_categories'] do
  json.data do
    json.total @view[:data].to_a.size
    json.list  @view[:data]
  end
end

json.partial! 'api/base', total: @data.size

json.cache! ['nested_categories'] do
  json.data @data
end

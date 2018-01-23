json.partial! 'api/base', total: @data.to_a.size

json.cache! ['nested_categories'] do
  json.data @data
end

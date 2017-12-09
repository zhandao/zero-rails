json.partial! 'api/base', total: @data.size

@data = @data.page(@page).per(@rows) if @page || @rows
json.cache! ['nested_categories'] do
  json.data @data.to_builder
end

Category.instance_variable_set("@get_nested_list", false)

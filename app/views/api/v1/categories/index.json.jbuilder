json.partial! 'api/base', total: @data.size

@data = @data.page(@_page).per(@_rows) if @_page || @_rows

json.cache! ['index_categories'] do
  json.data @data.to_builder
end

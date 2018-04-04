json.partial! 'api/base', total: @data.to_a.size

@data = @data.page(@page).per(@rows) if @page || @rows

json.cache! ['index_categories'] do
  json.data @data.to_builder
end

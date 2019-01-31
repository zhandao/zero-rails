json.partial! 'api/base'

json.cache! ['index_categories'] do
  json.data do
    json.total @view[:data].to_a.size

    data = @view[:data].page(@page).per(@rows) if @page || @rows
    json.list data.to_ha
  end
end

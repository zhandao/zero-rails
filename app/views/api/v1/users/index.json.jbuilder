json.partial! 'api/base'
json.data do
  json.list @view[:data].page(@page).per(@rows).to_a.to_builder
end

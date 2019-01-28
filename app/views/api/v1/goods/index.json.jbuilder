json.partial! 'api/base'

json.data do
  json.total @view[:data].to_a.size
  json.list @view[:data].page(@page).per(@rows)
end

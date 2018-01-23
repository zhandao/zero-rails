json.partial! 'api/base', total: @data.to_a.size

json.data do
  json.array! @data.page(@page).per(@rows) do |datum|
    json.(datum, *datum.show_attrs) if datum.present?
  end
end

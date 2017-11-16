json.partial! 'api/base', total: @data.size

json.data do
  json.array! @data.page(@_page).per(@_rows) do |datum|
    json.(datum, *datum.show_attrs) if datum.present?
  end
end

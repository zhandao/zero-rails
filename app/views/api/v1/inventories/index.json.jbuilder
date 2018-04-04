json.partial! 'api/base', total: @data.to_a.size

json.data do
  @data = @data.page(@page).per(@rows) if @page || @rows
  json.array! @data do |datum|
    json.(datum, *datum.show_attrs) if datum.present?
  end
end

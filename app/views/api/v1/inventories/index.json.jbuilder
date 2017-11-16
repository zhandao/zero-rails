json.partial! 'api/base', total: @data.size

json.data do
  @data = @data.page(@_page).per(@_rows) if @_page || @_rows
  json.array! @data do |datum|
    json.(datum, *datum.show_attrs) if datum.present?
  end
end

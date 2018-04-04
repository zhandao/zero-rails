json.partial! 'api/base', total: @data.to_a.size

json.data do
  # @data = @data.page(@page).per(@rows) if @page || @rows
  # json.array! @data do |datum|
  json.array! @data.page(@page).per(@rows) do |datum|
    json.(datum, *datum.show_attrs) if datum.present?
  end
end

# @data = @data.page(@page).per(@rows) if @page || @rows
# json.data @data
# json.data @data.page(@page).per(@rows).to_builder

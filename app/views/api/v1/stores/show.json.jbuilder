json.partial! 'api/base', total: 1

json.data do
  json.array! [@datum] do |datum|
    json.(datum, *datum.show_attrs) if datum.present?
  end
end

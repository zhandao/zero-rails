json.partial! 'api/base', total: 1

json.data @datum&.to_builder

json.partial! 'api/base', total: 1
json.data do
  json.user @current_user.id
  json.show @show
end

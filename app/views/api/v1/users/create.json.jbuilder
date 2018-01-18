unless @status
  error_class = Object.const_get("#{controller_name.camelize}Error") rescue nil
  error_name  = "#{action_name}_failed"
  @error_info = error_class.send(error_name).info.values if error_class.respond_to? error_name
  @_code, @_msg = @error_info
end

json.partial! 'api/base', total: 0
json.data @status || ''

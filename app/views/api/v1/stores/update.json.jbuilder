if @status == false
  @_code, @_msg = @error_info.present? ? @error_info : FloorsError.update_failed.info.values
end

json.partial! 'api/base', total: 0
json.data ''

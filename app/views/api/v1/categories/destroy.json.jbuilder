unless @status
  @_code, @_msg = @error_info.present? ? @error_info : CategoriesError.destroy_failed.info.values
end

json.partial! 'api/base', total: 0
json.data ''

if @status == false
  @_code, @_msg = @error_info.present? ? @error_info : GoodsError.destroy_failed.info.values
end

json.partial! 'api/base', total: 0
json.data ''

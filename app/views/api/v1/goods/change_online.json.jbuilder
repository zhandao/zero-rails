unless @status
  @_code, @_msg = @error_info.present? ? @error_info : GoodsError.change_online_failed(:info).values
end

json.partial! 'api/base', total: 0
json.data ''

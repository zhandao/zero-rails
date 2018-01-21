class Api::V1::InventoriesDoc < ApiDoc
  api :index, 'GET list of inventories.', builder: :index,
           use: %i[ created_start_at created_end_at value page rows ], skip: token do
    desc 'GET list of inventories.', view!: '请求来自的视图，允许值：<br/>', search_type!: '搜索的字段名，允许值：<br/>'

    query! :store_name,  String,  desc: '商店名' # TODO
    query  :search_type, String,  enum: %w[ name category_name unit price ], as: :field
    query  :export,      Boolean, desc: '是否将查询结果导出 Excel 文件'
  end
end

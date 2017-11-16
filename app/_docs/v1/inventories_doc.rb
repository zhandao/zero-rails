class V1::InventoriesDoc < ApiDoc

  open_api :index, 'Get list of Inventories.', builder: :index,
           use: [ :created_start_at, :created_end_at, :value, :page, :rows ], skip: token do
    desc 'Get list of Goods', view!: '请求来自的视图，允许值：', search_type!: '搜索的字段名，允许值：'

    query! :store_code,  String,  desc: '商店代号'
    query  :search_type, String,  enum: %w[ name creator category_name unit price ], as: :field
    query  :export,      Boolean, desc: '是否将查询结果导出 Excel 文件'
  end
end

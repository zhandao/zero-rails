class Api::V1::GoodsDoc < ApiDoc

  open_api :index, 'Get list of Goods.', builder: :index,
           use: token + [ :created_start_at, :created_end_at, :value, :page, :rows ] do
    desc 'Get list of Goods.', view!: '请求来自的视图，允许值：', search_type!: '搜索的字段名，允许值：'

    query :view, String, enum: {
        '所有物品 (default)': 'all',
                  '上线物品': 'online',
                  '下线物品': 'offline',
    }, dft: 'all'

    do_query by: {
        :search_type => { type: String, enum: %w[ name creator category_name unit price ], as: :field },
             :export => { type: Boolean, desc: '是否将查询结果导出 Excel 文件', examples: {
                 :right_input => true,
                 :wrong_input => 'wrong input'
             }}
    }

    examples :all, {
        :right_input => [ 'token', 'begin', 'end', 'value', 'page', 'rows', 'view', 'type', 'expo'],
        :wrong_input => []
    }
  end


  open_api :create, 'Create a Good, returns id of the good that was created.',
           builder: :success_or_not, use: token do
    form! 'for creating a good', data: {
               :name! => { type: String,  desc: '名字' },
        :category_id! => { type: Integer, desc: '子类 id', npmt: true, range: { ge: 1 }, as: :cate  },
               :unit! => { type: String,  desc: '单位' },
              :price! => { type: Float,   desc: '单价', range: { ge: 0} },
        # -- optional
           :is_online => { type: Boolean, desc: '是否上线?' },
             :remarks => { type: String,  desc: '其他说明' },
            :pic_path => { type: String,  desc: '图片路径', is: :url },
    },
          exp_by:       %i[ name category_id unit price ],
          examples: {
              :right_input => [ 'good1', 6, 'unit', 5.7 ],
              :wrong_input => [ 'good2', 0, 'unit', -1  ]
          }
  end


  open_api :show, 'Show a Good.', builder: :show, use: token + id


  open_api :update, 'Update a Good.', builder: :success_or_not, use: token + id do
    form! 'for updating a good', data: {
               :name => { type: String,  desc: '名字' },
        :category_id => { type: Integer, desc: '子类 id', npmt: true, range: { ge: 1 }, as: :cate  },
               :unit => { type: String,  desc: '单位' },
              :price => { type: Float,   desc: '单价', range: { ge: 0 } },
            :remarks => { type: String,  desc: '其他说明' },
           :pic_path => { type: String,  desc: '图片路径', is: :url },
          :is_online => { type: Boolean, desc: '是否上线' },
    }
  end


  open_api :destroy, 'Delete a Good.', builder: :success_or_not, use: token + id


  # /goods/:id/change_online
  open_api :change_online, 'Change online status of Good, will do: is_online = !is_online.',
           builder: :success_or_not, use: token do
    path! :id, Integer, desc: '要上/下线的物品 id'
  end
end

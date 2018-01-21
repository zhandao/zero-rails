class CreateGoods < ActiveRecord::Migration[5.1]
  def change
    create_table :goods, options: 'ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8' do |t|
      t.string     :name,       null: false,       index: true
      t.belongs_to :category,   foreign_key: true, index: true
      t.string     :unit,       null: false
      t.float      :price,      null: false
      t.string     :remarks
      t.string     :picture
      t.boolean    :on_sale,                       default: true
      t.datetime   :deleted_at

      t.timestamps
    end

    # add_index :goods, :name, unique: true
  end
end

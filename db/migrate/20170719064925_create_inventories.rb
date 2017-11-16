class CreateInventories < ActiveRecord::Migration[5.1]
  def change
    create_table :inventories, options: 'ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8' do |t|
      t.belongs_to :store,  foreign_key: true
      t.belongs_to :good,   foreign_key: true
      t.integer    :amount, null: false,       default: 0

      t.timestamps
    end

    add_index :inventories, [:store_id, :good_id], unique: true
  end
end

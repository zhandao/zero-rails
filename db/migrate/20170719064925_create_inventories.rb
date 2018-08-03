class CreateInventories < ActiveRecord::Migration::Current
  def change
    create_table :inventories, force: :cascade do |t|
      t.belongs_to :store,  foreign_key: true
      t.belongs_to :good,   foreign_key: true
      t.integer    :amount, null: false,       default: 0

      t.timestamps
    end

    add_index :inventories, [:store_id, :good_id], unique: true, using: :btree
  end
end

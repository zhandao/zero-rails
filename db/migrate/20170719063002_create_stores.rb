class CreateStores < ActiveRecord::Migration::Current
  def change
    create_table :stores, force: :cascade do |t|
      t.string   :name,      null: false
      t.string   :address,   null: false
      t.datetime :deleted_at#, index: true # https://ruby-china.org/topics/34540
    end

    add_index :stores, :name, unique: true, using: :btree
    add_index :stores, :address, unique: true, using: :btree
  end
end

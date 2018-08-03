class CreateCategories < ActiveRecord::Migration::Current
  def change
    create_table :categories, force: :cascade do |t|
      t.string     :name,          null: false
      t.references :base_category, index: true
      t.datetime   :deleted_at

      t.timestamps
    end

    add_index :categories, :name, unique: true, using: :btree
  end
end

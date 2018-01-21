class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories, options: 'ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8' do |t|
      t.string     :name,          null: false
      t.references :base_category, index: true
      t.datetime   :deleted_at

      t.timestamps
    end

    add_index :categories, :name, unique: true
  end
end

class CreatePermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :permissions, options: 'ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8' do |t|
      t.string  :name,    null: false
      t.string  :source
      t.string  :model,   null: false, default: ''
      t.string  :remarks

      t.timestamps
    end

    add_index :permissions, [:name, :source, :model], unique: true, name: 'permission_unique_index'
  end
end

class CreatePermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :permissions, options: 'ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8' do |t|
      t.string  :name,                              null: false
      t.boolean :is_method,        default: false
      t.string  :source
      t.string  :condition,        default: 'true', null: false
      t.string  :belongs_to_model, default: 'User'
      t.string  :remarks

      t.timestamps
    end

    add_index :permissions, [:name, :belongs_to_model], unique: true
  end
end

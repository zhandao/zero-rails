class CreatePermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :permissions, options: 'ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8' do |t|
      t.string  :name,    null: false
      t.string  :source
      t.string  :model
      t.string  :remarks

      t.timestamps
    end
  end
end

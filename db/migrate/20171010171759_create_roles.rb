class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles, options: 'ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8' do |t|
      t.string     :name,      null: false
      t.string     :model
      t.string     :remarks
      t.references :base_role, index: true

      t.timestamps
    end
  end
end

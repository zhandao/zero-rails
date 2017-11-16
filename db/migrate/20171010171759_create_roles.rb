class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles, options: 'ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8' do |t|
      t.string     :name,             null: false
      t.string     :condition,        null: false,     default: 'true'
      t.string     :belongs_to_model, default: 'User'
      t.string     :remarks
      t.references :base_role,        index: true

      t.timestamps
    end

    add_index :roles, [:name, :belongs_to_model], unique: true
  end
end

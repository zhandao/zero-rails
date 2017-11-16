class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, options: 'ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8' do |t|
      t.string   :name,            null: false
      t.string   :password_digest, null: false
      t.string   :email
      t.string   :phone_number
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :users, :name,         unique: true # name: 'xx_index'
    add_index :users, :email,        unique: true
    add_index :users, :phone_number, unique: true
  end
end

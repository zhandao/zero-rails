class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, force: :cascade do |t|
      t.string   :name,            null: false
      t.string   :password_digest, null: false
      t.integer  :token_version,   default: 0
      t.string   :email
      t.string   :phone_number
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :users, :name,         unique: true, using: :btree # name: 'xx_index'
    add_index :users, :email,        unique: true, using: :btree
    add_index :users, :phone_number, unique: true, using: :btree
  end
end

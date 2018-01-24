class CreateStores < ActiveRecord::Migration[5.1]
  def change
    create_table :stores, options: 'ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8' do |t|
      t.string   :name,      null: false
      t.string   :address,   null: false
      t.datetime :deleted_at#, index: true # https://ruby-china.org/topics/34540
    end

    add_index :stores, :name, unique: true
    add_index :stores, :address, unique: true
  end
end

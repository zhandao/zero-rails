class CreateStores < ActiveRecord::Migration[5.1]
  def change
    create_table :stores, options: 'ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8' do |t|
      t.string   :code,       null: false
      t.string   :addr,       null: false
      t.datetime :deleted_at#, index: true # https://ruby-china.org/topics/34540
    end

    add_index :stores, :code, unique: true
    add_index :stores, :addr, unique: true
  end
end

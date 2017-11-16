class CreateVerifications < ActiveRecord::Migration[5.1]
  def change
    create_table :verifications, options: 'ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8' do |t|
      t.belongs_to :user,      foreign_key: true
      t.string     :code,      null: false
      t.string     :type,      default: 'phone'
      t.datetime   :expire_at #, default: Time.at(0).to_datetime
      t.datetime   :verify_at

      t.timestamps
    end
  end
end

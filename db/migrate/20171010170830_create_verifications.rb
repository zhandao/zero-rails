class CreateVerifications < ActiveRecord::Migration::Current
  def change
    create_table :verifications, force: :cascade do |t|
      t.belongs_to :user,      foreign_key: true
      t.string     :code,      null: false
      t.string     :type,      default: 'phone'
      t.datetime   :expire_at #, default: Time.at(0).to_datetime
      t.datetime   :verify_at

      t.timestamps
    end
  end
end

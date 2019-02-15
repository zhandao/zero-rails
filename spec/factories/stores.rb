FactoryBot.define do
  factory :store do
    name       'store'
    address    'some where'
    # deleted_at { DateTime.now }
  end
end

# == Schema Information
#
# Table name: stores
#
#  id         :bigint(8)        not null, primary key
#  address    :string           not null
#  deleted_at :datetime
#  name       :string           not null
#
# Indexes
#
#  index_stores_on_address  (address) UNIQUE
#  index_stores_on_name     (name) UNIQUE
#

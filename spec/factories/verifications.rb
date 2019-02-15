FactoryBot.define do
  factory :verification do
    belongs_to ""
    code "MyString"
    type ""
  end
end

# == Schema Information
#
# Table name: verifications
#
#  id         :bigint(8)        not null, primary key
#  code       :string           not null
#  expire_at  :datetime
#  type       :string           default("phone")
#  verify_at  :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint(8)
#
# Indexes
#
#  index_verifications_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

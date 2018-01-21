class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include TokenForModel
  include BuilderSupport
  include SecureStorage

  def self.soft_destroy
    acts_as_paranoid
    builder_rmv :deleted_at
    builder_add :deleted_at, when: -> { deleted_at.present? }
  end
end

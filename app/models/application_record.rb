class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include TokenForModel
  include BuilderSupport
  include SecureStorage
end

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include TokenForModel
  include SecureStorage
end

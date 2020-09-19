# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include TokenForModel

  def self.soft_destroy # TODO rename -> soft_destroy_support
    acts_as_paranoid
    active_serialize_rmv :deleted_at
    # active_serialize_add :deleted_at, when: -> { deleted_at.present? }
  end
end

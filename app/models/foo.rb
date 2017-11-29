# *** Generated by Zero [ please make sure that you have checked this file ] ***

class Foo < ApplicationRecord
  acts_as_paranoid

  belongs_to :user

  has_many :stars

  has_many :sub_foos, class_name: 'Foo', foreign_key: 'sub_foo_id', dependent: :destroy
  belongs_to :sub_foo, class_name: 'Foo', optional: true

  scope :ordered, -> { all }

  # desc
  def self.bar
    # TODO
  end

  # change its online status
  def change_status
    # TODO
  end

  # desc
  def cool
    # TODO
  end
end
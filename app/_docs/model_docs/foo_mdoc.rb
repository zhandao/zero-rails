class FooMdoc < ModelDoc
  soft_destroy

  belongs_to :user, polymorphic: true
  has_many :stars
  self_joins :has_many

  string! :name, index: true, unique: true, show: true
  boolean :actived, default: false, show: true
  end_of_attrs

  index :user, :name

  scope :ordered

  cmethod :bar

  imethod :change_status, 'change its online status' do
    wh 'there is no call to #page' do
      it :success
      it :does_something, is_expected: [1, 2, 3]
    end
  end

  imethod :cool
end

require 'rails_helper'
require 'dssl/model'

RSpec.describe Permission, type: :model do
  let(:permission) { create(:permission) }
  subject { permission }
end

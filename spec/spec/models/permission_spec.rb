require 'rails_helper'
require 'dssl/model'

RSpec.describe Permission, type: :model do
  let(:permission) { create(:permission) }
  subject { permission }

  desc '.all_view', '[scope]' do
    it { called has_size: 1 }
  end

  desc '.page_view', '[scope]' do
    it { called get: [] }
    context 'when permissions having `path`' do
      let(:page_permission) { create(:permission, path: '/') }
      before { page_permission }
      it('returns them') { called get: [page_permission] }
    end
  end

  desc '.floor_view', '[scope]' do
    it { called get: [] }
    context 'when permissions having `source: floor`' do
      let(:floor_permission) { create(:permission, source: 'floor') }
      before { floor_permission }
      it('returns them') { called get: [floor_permission] }
    end
  end

  desc '.from_base_permissions', '[scope]' do
    before { permission; create(:permission, base_permission_id: 1) }
    it { called get: [permission] }
  end
end

class Api::V1::GoodsSpdoc < BaseSpdoc

  describe :index do
    biz 'business scenario x' do
      context 'when case y' do
        it 'does something', when: :req, view: 'wrong value', its: :code, is_expected: :invalid_param
        it when: :merge, page: 2, rows: 8
        it 'does another thing', when: { view: 'wrong value' }, its: {
            code!: :'eq 200',
            data!: :'include(name: \'good1\')'
        }
      end
    end

    it 'does z'
  end

  describe :show do
    biz 'business scenario x' do
      context 'when case y' do
        it 'does something'
        oneline_it :merge, page: 2, rows: 10
        it 'does another thing'
      end
    end

    it 'does z'
  end
end

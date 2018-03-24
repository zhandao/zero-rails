require 'rails_helper'

RSpec.describe Array do
  describe '#per and #page' do
    subject { (1..11).to_a }

    context '.page().per()' do
      it { expect(subject.page(2).per(5)).to eq (6..10).to_a }
      it { expect(subject.page(3).per(5)).to eq [11] }

      context 'when overflowing' do
        it { expect(subject.page(2).per(11)).to eq [ ] }
        it { expect(subject.page(1).per(100)).to eq subject }
      end
    end

    context '.per()' do
      it 'expect page number defaults to 1' do
        expect(subject.per(3)).to eq (1..3).to_a
      end
    end

    describe 'abnormal call' do
      context '.page() # NOT SUPPORTED' do
        it 'likes doing nothing' do
          expect(subject.page(2)).to eq subject
        end

        context '.per().page() # NOT SUPPORTED' do
          it 'does not expected behavior' do
            expect(subject.per(5).page(2)).to eq subject.per(5)
          end
        end
      end

      context 'when doing multiple calling' do
        it('supports re-calling #page') { expect(subject.page(1).page(2).per(3)).to eq (4..6).to_a }
        it('does not support re-calling #per') { expect(subject.page(2).per(3).per(5)).to eq (4..6).to_a }
      end

      context 'when pass abnormal args' do
        it { expect(subject.page(0).per(0)).to eq subject.page.per }
        # not number
        # string number
      end
    end
  end

  describe '#to_builder' do
  end
end

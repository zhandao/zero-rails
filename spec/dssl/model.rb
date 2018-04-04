def func action, description = nil, focus_on: nil, &block
  _action = action.is_a?(Symbol) ? "##{action}" : action
  describe "#{_action}#{', ' + description if description}" do
    action.delete!('.') if action.is_a? String
    let(:action) { action }
    let(:focus_on) { focus_on }
    instance_eval(&block)
  end
end

def called by: [], to: nil, **expectation
  obj = to || subject
  obj = obj.class if !action.is_a?(Symbol) && obj.class != Class
  by = by.is_a?(Hash) ? [by] : Array(by)
  expect(obj.send(action, *by)).to instance_exec(&_model_expectation_blks(**expectation))
end

def _model_expectation_blks get: nil, all_attrs: nil, has_size: nil
  if !all_attrs.nil?
    -> { all(have_attributes(all_attrs)) }
  elsif !has_size.nil?
    -> { have_size has_size == :all ? subject.class.count : has_size }
  else
    get = instance_exec(&get) if get.is_a?(Proc)
    -> { eq get == :all ? subject.class.all : get }
  end
end

def set attrs
  attrs.each { |attr, val| subject.send("#{attr}=", val) }
end

def expect_it
  expect(subject.send(focus_on))
end

def acts_as_paranoid
  func :destroy, focus_on: :deleted_at do
    it 'is destroy softly' do
      expect_it.to be_nil
      subject.destroy
      expect_it.not_to be_nil
      expect(subject.class.find_by(id: subject.id)).to be_nil
    end
  end
end

def func method, description = nil, focus_on: nil, &block
  _action = method.is_a?(Symbol) ? "##{method}" : method
  describe "#{_action}#{', ' + description if description}" do
    method.delete!('.') if method.is_a? String
    let(:func_method) { method }
    let(:focus_on) { focus_on }
    instance_eval(&block)
  end
end

def calls by: [], of: nil, **expectation
  obj = of || subject
  obj = obj.class if !func_method.is_a?(Symbol) && obj.class != Class
  by = by.is_a?(Hash) ? [by] : Array(by)
  expect(obj.send(func_method, *by)).to instance_exec(&_model_expectation_blks(**expectation))
end

def _model_expectation_blks get: nil, all_attrs: nil, have_size: nil
  if !all_attrs.nil?
    -> { all(have_attributes(all_attrs)) }
  elsif !have_size.nil?
    -> { have_size have_size == :all ? subject.class.count : have_size }
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
    it 'is destroyed softly' do
      expect_it.to be_nil
      subject.destroy
      expect_it.not_to be_nil
      expect(subject.class.find_by(id: subject.id)).to be_nil
    end
  end
end

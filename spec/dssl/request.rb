module Temp; cattr_accessor :action_path do { } end; end

def desc action, http_method, path, description = nil, focus_on: nil, &block
  Temp.action_path[action] = [http_method, path + '.json']
  _action = action.is_a?(Symbol) ? "##{action}" : action
  describe [_action, ', ', http_method, ' ', path, ' - ', description].join do
    action.delete!('.') if action.is_a? String
    let(:http_method) { http_method }
    let(:path) { path }
    let(:focus_on) { focus_on }
    instance_eval(&block)
  end
end

def prepare_goods name: nil, inv: 10
  create(:base_category)
  goods = create_list(:good, 5) unless name
  goods = name.map { |n| create(:good, name: n) } if name
  Inventory.update_all(amount: inv)
  goods
end

def called by: nil, p: nil, with: nil, **expectation
  p = params.slice(params.keys.grep(p)) if p
  with = params.merge(with) if with
  parameters = by || p || with || params
  send(http_method, path + '.json', params: parameters)
  if expectation.present?
    obj = subject[:code] if expectation.key? :get
    expect(obj || subject[:data]).to instance_exec(&_expectation_blks(**expectation))
  end
end

def _expectation_blks get: nil, all_attrs: nil, has_size: nil
  if !all_attrs.nil?
    -> { all(have_attributes(all_attrs)) }
  elsif !has_size.nil?
    -> { have_size has_size }
  else
    -> { eq get }
  end
end

def callto action, with: { }
  send(*Temp.action_path[action], params: send("#{action}_params").merge(with))
  expect(MultiJson.load(response.body, symbolize_keys: true)[:code]).to eq 200
end

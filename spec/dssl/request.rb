module Temp
  cattr_accessor(:action_path) { { } }
  cattr_accessor(:path) { { } }
end

def self_name
  self.to_s.delete('#<').split('::').first(3).join('::')
end

def _process_path path
  path.gsub(/{[^}]*}/) { |p| Temp.path[self_name][p.delete('{}').to_sym] || 1 } + '.json'
end

def path params
  Temp.path[self_name] = params
end

def api action, http_method, path, description = nil, token_needed = false, focus_on: nil, &block
  (Temp.action_path[self_name] ||= { })[action] ||= [http_method, _process_path(path)]
  _action = action.is_a?(Symbol) ? "##{action}" : action
  describe [_action, ', ', http_method, ' ', path, ' - ', description].join do
    action.delete!('.') if action.is_a? String
    let(:http_method) { http_method }
    let(:path) { path }
    let(:token_needed) { token_needed }
    let(:focus_on) { focus_on }

    if token_needed
      it 'checks token', :skip_before do
        error_code = ApiError.invalid_token.code
        request headers: { Authorization: nil }, get: error_code
        # requested get: ApiError.invalid_param.info[:code]
        request headers: { Authorization: 'Bearer 123' }, get: error_code
        invalid_user = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImFAYi5jIiwidWlkIjoidCIsInZlcnNpb24iOjEsImV4cCI6IjE1' \
                       'MTc1NzYxODkifQ.7CeA1P8iBK8rTaw1nt7wk6QqB2IQMcVvARTTrTdvPOE'
        request headers: { Authorization: invalid_user }, get: error_code
      end
    end

    instance_eval(&block)
  end
end

def skippable_before(sign = nil, &block)
  before do |example|
    unless example.metadata[sign || :skip_before]
      instance_eval(&block)
    end
  end
end

def before_when(sign, &block)
  before do |example|
    if example.metadata[sign]
      instance_eval(&block)
    end
  end
end

def prepare_goods name: nil, inv: 10
  create(:base_category)
  goods = create_list(:good, 5) unless name
  goods = name.map { |n| create(:good, name: n) } if name
  Inventory.update_all(amount: inv)
  goods
end

def req by: nil, p: nil, with: nil, headers: { }, to: nil, **expectation
  params = try(:params) || { }
  p = params.slice(params.keys.grep(p)) if p
  with = params.merge(with) if with
  parameters = by || p || with || params
  headers.merge!(Authorization: 'Bearer ' + user.token) if token_needed && !headers.key?(:Authorization)
  send(http_method, _process_path(path), params: parameters, headers: headers)

  if expectation.present?
    obj = subject[:code] if expectation.key? :get
    expect(obj || subject[:data]).to instance_exec(&_req_expectation_blks(**expectation))
  end
end

alias reqed req
alias request req
alias requested req

def _req_expectation_blks get: nil, all_attrs: nil, has_size: nil, has_attr: nil, include: nil, has_key: nil, data: nil
  if !all_attrs.nil?
    -> { all(have_attributes(all_attrs)) }
  elsif !has_attr.nil?
    -> { have_attributes(has_attr) }
  elsif !include.nil?
    -> { include(include) }
  elsif !has_key.nil?
    -> { have_key has_key }
  elsif !has_size.nil?
    -> { have_size has_size }
  elsif !data.nil?
    -> { eq data }
  else
    -> { eq get }
  end
end

def req_to action, token_needed = false, with: { }
  headers = { Authorization: 'Bearer ' + user.token } if token_needed
  send(*Temp.action_path[self_name][action], params: send("#{action}_params").merge(with), headers: headers || { })
  expect(MultiJson.load(response.body, symbolize_keys: true)[:code]).to eq 200
end

def req_to! action, with: { }
  req_to action, true, with: with
end

def it_checks_permission
  it 'checks permission', :without_permission_mock do
    requested get: ApiError.permission_error.code
  end
end

def permission_mock args
  skippable_before :without_permission_mock do
    args.each do |action, pmts|
      pmts.each { |pmt| allow_any_instance_of(User).to receive(action).with(*(pmt.is_a?(Array) ? pmt : [pmt, nil])).and_return(true) }
    end
  end
end

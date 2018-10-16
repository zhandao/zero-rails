def main_logic(&block)
  describe 'tests for main logic', &block
end

def params_combination(&block)
  describe 'tests for params combination', &block
end

def let_params(**hash, &block)
  context "when passing params #{hash}" do
    before { params.merge!(hash) }
    instance_eval(&block)
  end
end

def biz_error(&block)
  describe 'tests for param & business errors', &block
end

module Temp
  cattr_accessor(:action_path) { { } }
  cattr_accessor(:path) { { } }
end

def self_name
  self.to_s.delete('#<').split('::').first(3).last[3..-1]
end

def happy_spec
  api_ver, entity_name = self_name[/V[1-9]?/], self_name.sub(/V[1-9]?/, '')

  let(:error_cls) { ('Error::' + entity_name).constantize }
  ns = api_ver ? "Api::#{api_ver}::" : 'Api::'
  let(:controller) { (ns + entity_name + 'Controller').constantize }

  # Set subject to be the hashed response
  subject { MultiJson.load(response.body, symbolize_keys: true) }
  let(:response_status) { subject[:result][:code] }
end

def _process_path path
  path.gsub(/{[^}]*}/) { |p| Temp.path[self_name][p.delete('{}').to_sym] || 1 } + '.json'
end

def path params
  Temp.path[self_name] = params
end

def mock_ins receive, rt: nil
  allow_any_instance_of(controller).to receive(receive).and_return(rt)
end

def mock_ins! receive, rt: nil
  expect_any_instance_of(controller).to receive(receive).and_return(rt)
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
        error_code = Error::Api.invalid_token.code
        request headers: { Authorization: nil }, get: error_code
        # requests get: Error::Api.invalid_param.info[:code]
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

def req by: nil, p: nil, with: nil, headers: { }, to: nil, **expectations
  params = try(:params) || { }
  p = params.slice(params.keys.grep(p)) if p
  with = params.merge(with) if with
  parameters = by || p || with || params
  headers.merge!(Authorization: 'Bearer ' + user.token) if token_needed && !headers.key?(:Authorization)
  send(http_method, _process_path(path), params: parameters, headers: headers)

  subj = MultiJson.load(response.body, symbolize_keys: true) # TODO HACK for fixing subject cannot reload
  # pp subj
  expectations&.each do |(key, val)|
    obj =  key == :get ? subj[:result][:code] : subject[:data] # TODO HACK as above, refactoring by reading OutPut::Config
    expect(obj || subj[:data]).to instance_exec(&_req_expectation_blks(key => val))
  end
end

alias reqs req
alias request req
alias requests req

def _req_expectation_blks get: nil, all_have_attrs: nil, have_size: nil, include: nil, have_key: nil, data_eq: nil
  if !all_have_attrs.nil?
    -> { all(have_attributes(all_have_attrs)) }
  elsif !include.nil?
    -> { include(include) }
  elsif !have_key.nil?
    -> { have_key have_key }
  elsif !have_size.nil?
    -> { have_size have_size }
  elsif !data_eq.nil?
    -> { eq data_eq }
  else
    get = 0 if get == :success # TODO
    get = error_cls.send(get).code if get.is_a?(Symbol)
    -> { eq get }
  end
end

def req_to action, token_needed = false, with: { }
  headers = { Authorization: 'Bearer ' + user.token } if token_needed
  send(*Temp.action_path[self_name][action], params: send("#{action}_params").merge(with), headers: headers || { })
  MultiJson.load(response.body, symbolize_keys: true).tap do |result|
    expect(result[:result][:code]).to eq 200
  end
end

def req_to! action, with: { }
  req_to action, true, with: with
end

def it_checks_permission
  it 'checks permission', :without_permission_mock do
    requests get: Error::Api.permission_error.code
  end
end

def permission_mock args
  skippable_before :without_permission_mock do
    args.each do |action, pmts|
      pmts.each do |pmt|
        allow_any_instance_of(User)
            .to receive(action)
                    .with(*(pmt.is_a?(Array) ? pmt : [pmt, nil]))
                    .and_return(true)
      end
    end
  end
end

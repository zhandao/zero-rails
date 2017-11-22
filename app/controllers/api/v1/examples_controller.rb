class Api::V1::ExamplesController < Api::V1::BaseController

  apis_tag name: 'EEExam', desc: 'descccc'

  components do
    schema :DogSchema => [ { id: Integer, name: String }, dft: { id: 1, name: 'pet' } ]
    resp   :Resp  => [ 'bad request', :json ]
    query! :Query => [ :name, String, desc: 'user name' ]
    schema :Uuid  => [ String, must_be: '2' ]
  end

  open_api :index, '(SUMMARY) this api blah blah ...', use: ['Token'] do
    # this_api_is_invalid! 'this api is expired!'
    desc 'Optional multiline or single-line Markdown-formatted description',
         id: 'description<br/>id',
         email_addr: 'user_email_addr\'s desc'
    email = 'zero@zero-rails.org'

    query! :id,         Integer, enum: 0..5,     length: [1, 2], pattern: /^[0-9]$/, range: {gt:0, le:5}
    query! :done,       Boolean, must_be: false, default: true,  desc: 'must be false'
    query  :email_addr, String,  lth: :ge_3,     dft: email # is_a: :email
    query  :doge, :DogSchema

    # form! 'form', type: { id!: Integer, name: String }
    # file :xwww, 'application/x-www-form-urlencoded'
    response :success, 'success response', :json#, type: :Pet
    security :ApiKeyAuth

    override_response 200, { data: {
        type: [
            String
        ]
    }}
  end

  def index
    ### Business Error Processor DSL
    # 这部分大约[总共]会多 20-40 ms - MacMini
    # processor binding # 变量声明之前
    # foo = 'foooo'
    # woo = 'woooo'
    # @bar = 123
    # make_sure :@bar, is: :not_null
    # make_sure(:foo).is :not_null
    # make_sure_not_null [:oow, woo] # 自己传值，性能更好，也无需写 binding
    # make_sure(:foo).is :exist
    # make_sure(:foo).is :cool

    ### Exception
    # Tip: the param type is automatically transformed by SwgdParamsValidator
    #      here is: ps.id(.to_i) or p[:id](.to_i)
    ExamplesError.name_not_found if input.id.eql? 1
    # this error is defined in super class ApiError
    ExamplesError.invalid_param  if input.id.eql? 2
    ApiError.invalid_param       if input.id.eql? 3

    ### Render
    # ren_ok data: params[:id] # general usage
    # ren_ok data: input.id       # [pa] is the agent of params, see: lib/zero/params_agent.rb
    # ren data: input.id          # code defaults to 200
    # ren input.done              # key defaults to :data
    out input.done             # ren()'s alias, but it would be weird to write with return: return out data
    # out input.user_email_addr   # it will be setting by default value if the param is set a default value
  end


  open_api :show, '', use: ['Token'] do
    path! :id, Integer
    param_ref    :Query
    query! :uuid, :Uuid # type 传 symbol 表示 ref
    response_ref '123' => :Resp
  end

  def show
    # out request.path
    @show = true
  end
end

# class ExamplesError < V1Error
#   set_for :index
#   mattr_reader :name_not_found, 'can not find the name', 404
#   # {:_public=>[:invalid_param], :index=>[:name_not_found]}
#   # 这个方法实现同样目的，但可能无法获得 RubyMine 的自动补全
#   # define :error_name, 'error info', 200
# end


# class ExamplesErrorMapper < ApiErrorMapper
#   def self.not_null(obj)
#     puts '#{obj.name} / #{obj.value}'
#   end
# end

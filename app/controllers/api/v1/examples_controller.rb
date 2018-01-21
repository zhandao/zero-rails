class ExamplesError < V1Error
  set_for :index
  mattr_reader :name_not_found, 'can not find the name', 404
end

class Api::V1::ExamplesController < Api::V1::BaseController
  doc_tag name: 'Examples', desc: 'tag_desc'

  components do
    schema :DogSchema => [ { id: Integer, name: String }, dft: { id: 1, name: 'pet' } ]
    schema :PetSchema => [ not: [ Integer, Boolean ] ]
    resp   :BadRqResp => [ 'bad request', :json ]
    query! :NameQuery => [ :name, String, desc: 'user name' ]
  end

  api :index, '(SUMMARY) this api blah blah ...', use: ['Token'] do
    # this_api_is_invalid! 'this api is expired!'
    desc 'Optional multiline or single-line Markdown-formatted description',
         id: 'description of<br/>id',
         email: 'user_email_addr\'s desc'
    email = 'zero@zero-rails.org'

    query! :id,    Integer, enum: 0..5,     length: [1, 2], pattern: /^[0-9]$/, range: { gt: 0, le: 5 }
    query! :done,  Boolean, must_be: false, default: true,  desc: 'must be false'
    query  :email, String,  lth: :ge_3,     dft: email # is_a: :email

    query :test_type, type: String
    query :combination, one_of: [ :DogSchema, String, { type: Integer, desc: 'integer input'}]

    form data: {
        :combination_in_data => { any_of: [ Integer, String ] }
    }

    # file :a_file, 'application/x-www-form-urlencoded'
    response :success, 'success response', :json#, data: :Pet
    security :Token

    resp 200, '', :json, data: {
        a: String
    }
  end

  def index
    ### Exception
    # Tip: the param type is automatically transformed by SwgdParamsValidator
    #      here is: ps.id(.to_i) or p[:id](.to_i)
    ExamplesError.name_not_found! if @id.eql? 1
    # this error is defined in super class ApiError
    ExamplesError.invalid_param!  if @id.eql? 2
    ApiError.invalid_param!       if @id.eql? 3

    ### Render
    output
  end


  api :show, '', use: ['Token'] do
    path! :id, Integer
    param_ref    :NameQuery
    query  :doge, :DogSchema
    response_ref '123' => :BadRqResp
  end

  def show
    # out request.path
    @show = true
  end
end

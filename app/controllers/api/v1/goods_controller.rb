class Api::V1::GoodsController < Api::V1::BaseController
  include ActiveRecordErrorsRescuer

  def index
    @data = Good.send("#{@view}_view")
                .created_between(@start, @end)
                .search_by(@field, @value)
                .ordered
    export_goods if @export
  end


  logic :valid, fail: :invalid_param do
    false
  end

  def show
    make_sure(1).valid
    @datum = @good
  end


  def create
    permitted.merge! category: Category.find(@cate), creator: current_user.name
    Good.create! permitted
  end


  def update
    permitted[:category] = Category.find(@cate) if @cate
    @good.update! permitted
  end


  def destroy
    @status = @good.destroy
  end


  def change_online
    @status = @good.change_online
  end
end

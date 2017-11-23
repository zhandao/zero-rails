class Api::V1::GoodsController < Api::V1::BaseController
  include ActiveRecordErrorsRescuer

  def index
    @data = Good.send("#{@_view}_view")
                .created_between(@_start, @_end)
                .search_by(@_field, @_value)
                .ordered
    export_goods if @_export
  end


  def show
    @datum = @good
  end


  def create
    permitted.merge! category: Category.find(@_cate), creator: current_user.name
    Good.create! permitted
  end


  def update
    permitted[:category] = Category.find(@_cate) if @_cate
    @good.update! permitted
  end


  def destroy
    @status = @good.destroy
  end


  def change_online
    @status = @good.change_online
  end
end

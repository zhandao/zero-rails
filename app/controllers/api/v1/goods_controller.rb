class Api::V1::GoodsController < Api::V1::BaseController
  include ActiveRecordErrorsRescuer

  def index
    @data =
        Good.send("#{@_view}_view")
            .created_between(@_start, @_end)
            .search_by(@_field, @_value)
            .ordered
    export_goods if @_export
  end


  def show
    @datum = Good.find_by! permitted
  end


  def create
    permitted.merge! category: Category.find(@_cate), creator: current_user.name
    Good.create! permitted
  end


  def update
    permitted.merge! category: Category.find(@_cate) if @_cate
    Good.find(@_id).update! permitted
  end


  def destroy
    @status = Good.find(@_id).destroy
  end


  def change_online
    @status = Good.find(@_id).change_online
  end
end

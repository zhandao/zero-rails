class Api::V1::GoodsController < Api::V1::BaseController
  include ActiveRecordErrorsRescuer

  # if_can :manage, source: Good, allow: :all

  def index
    @data = Good.send(@view).created_between(@start, @end).search(@field, with: @value).ordered
    export_goods if @export
  end


  def show
    @datum = @good
  end


  def create
    Good.create! permitted
  end


  def update
    @good.update! permitted
  end


  def destroy
    @status = @good.destroy
  end


  def change_onsale
    @status = @good.change_onsale
  end
end

class Api::V1::GoodsController < Api::V1::BaseController
  include ActiveRecordErrorsRescuer

  if_can :manage, source: Good, allow: :all

  def index
    @data = Good.send(@view).created_between(@start, @end).search(@field, with: @value).ordered
    @export ? export_goods : build_with(data: @data)
  end

  def show
    build_with datum: @good
  end

  def create
    check Good.create! permitted
  end

  def update
    check @good.update! permitted
  end

  def destroy
    check @status = @good.destroy
  end

  def change_onsale
    check @good.change_onsale
  end
end

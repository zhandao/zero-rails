class Api::V1::CategoriesController < Api::V1::BaseController
  include ActiveRecordErrorsRescuer

  skip_token only: %i[ index nested_list ]

  def index
    @data = Category.all
  end


  def nested_list
    @data = Category.from_base_categories.get_nested_list
  end


  def create
    Category.create! permitted
  end


  def update
    @category.update! permitted
  end


  def destroy
    @status = @category.destroy
  end
end

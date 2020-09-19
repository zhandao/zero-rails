# frozen_string_literal: true

class Api::V1::CategoriesController < Api::V1::BaseController
  # TODO: gen #Class
  include ActiveRecordErrorsRescuer

  skip_token only: %i[ index nested_list ]

  def index
    build_with data: Category.all
  end

  def nested_list
    build_with data: Category.from_base_categories.get_nested_list
  end

  def create
    check Category.create! permitted
  end

  def update
    check @category.update! permitted
  end

  def destroy
    check @status = @category.destroy
  end
end

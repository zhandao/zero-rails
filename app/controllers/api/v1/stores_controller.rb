# frozen_string_literal: true

class Api::V1::StoresController < Api::V1::BaseController
  include ActiveRecordErrorsRescuer

  skip_token only: %i[ index show ]

  def index
    build_with data: Store.all
  end

  def create
    check Store.create! permitted
  end

  def show
    build_with datum: @store
  end

  def update
    check @store.update! permitted
  end

  def destroy
    check @store.destroy
  end
end

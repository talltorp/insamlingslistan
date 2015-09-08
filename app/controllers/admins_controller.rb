class AdminsController < ApplicationController
  before_filter :validate_authentication_code

  def show
    @insamling = Insamling.find(params[:insamling_id])
    @need = Need.new
  end

  private

  def validate_authentication_code

  end
end

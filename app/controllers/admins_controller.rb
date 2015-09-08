class AdminsController < ApplicationController
  before_filter :validate_authentication_code

  def show
    @insamling = insamling
    @need = Need.new
  end

  private

  def validate_authentication_code
    unless insamling.admin_token == admin_token_from_params
      redirect_to insamling_url(insamling)
    end
  end

  private

  def admin_token_from_params
    params[:id]
  end

  def insamling
    @insamling ||= Insamling.find(params[:insamling_id])
  end
end

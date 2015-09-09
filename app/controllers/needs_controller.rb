class NeedsController < ApplicationController
  before_filter :validate_admin_token

  def create
    @insamling = insamling
    @need = insamling.needs.create(need_params)
    redirect_to insamling_admin_url(insamling.id, insamling.admin_token)
  end

  def destroy
    @insamling = insamling
    @need = Need.find(params[:id])
    @need.destroy

    redirect_to insamling_admin_url(insamling.id, insamling.admin_token)
  end

  private

  def validate_admin_token
    unless insamling.admin_token == admin_token_in_params
      redirect_to insamling_url(insamling)
    end
  end

  def insamling
    @insamling ||= Insamling.find(params[:insamling_id])
  end

  def need_params
    params.require(:need).permit(:title, :description)
  end

  def admin_token_in_params
    params[:admin_token]
  end
end

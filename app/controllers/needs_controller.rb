class NeedsController < ApplicationController
  def create
    @insamling = Insamling.find(params[:insamling_id])
    @need = @insamling.needs.create(need_params)
    redirect_to insamling_admin_url(@insamling.id, @insamling.admin_token)
  end

  def destroy
    @insamling = Insamling.find(params[:insamling_id])
    @need = Need.find(params[:id])
    @need.destroy

    redirect_to insamling_admin_url(@insamling.id, @insamling.admin_token)
  end

  private

  def need_params
    params.require(:need).permit(:title, :description)
  end
end

class NeedsController < ApplicationController
  before_filter :validate_user_logged_in

  def create
    @insamling = insamling
    @need = insamling.needs.create(need_params)
    redirect_to insamling_url(insamling)
  end

  def destroy
    @insamling = insamling
    @need = Need.find(params[:id])
    @need.destroy

    redirect_to insamling_url(insamling)
  end

  private

  def validate_user_logged_in
    unless session[:current_user] == insamling.user_email
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

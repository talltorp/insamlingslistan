class InsamlingsController < ApplicationController
  def new
    @insamling = Insamling.new
  end

  def show
    @insamling = Insamling.find(params[:id])
  end

  def create
    insamling = Insamling.new(insamlings_params)

    if insamling.save
      InsamlingMailer.send_confirmation_email(insamling).deliver_now
      flash[:notice] = "Insamlingen skapades. Kolla din mail för inloggningsuppgifter"
      redirect_to insamling_url(insamling)
    end
  end

  private

  def insamlings_params
    params.require(:insamling).permit(:about, :description, :user_email)
  end
end

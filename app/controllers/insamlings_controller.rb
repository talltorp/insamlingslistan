class InsamlingsController < ApplicationController
  before_filter :set_current_user, on: [:show]

  def new
    @insamling = Insamling.new
  end

  def show
    @insamling = Insamling.find(params[:id])
  end

  def create
    @insamling = Insamling.new(insamlings_params)

    if @insamling.save
      InsamlingMailer.send_confirmation_email(@insamling).deliver_now
      flash[:notice] = "Insamlingen skapades. Kolla din mail för inloggningsuppgifter"
      redirect_to insamling_url(@insamling)
    else
      render :new
    end
  end

  private

  def set_current_user
    if session[:current_user]
      @current_user = session[:current_user]
    end
  end

  def insamlings_params
    params.require(:insamling).permit(
      :about,
      :description,
      :user_email,
      :when,
      :location
    )
  end
end

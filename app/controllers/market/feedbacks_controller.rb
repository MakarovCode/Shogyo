class Market::FeedbacksController < ApplicationController

  before_action :authenticate_user!
  before_action :load_data

  def new
    @feedback = current_user.feedbacks.new
    @publication_id = params[:publication_id]
  end

  def create
    @feedback = current_user.feedbacks.new params_permit_create
    if @feedback.save
      if params[:redirect_to].nil?
        redirect_to market_publication_path(@feedback.publication), notice: "¡Gracias por contactarnos! el caso será estudiado y te notificaremos con la respuesta"
      else
        redirect_to params[:redirect_to], notice: "¡Gracias por contactarnos! el caso será estudiado y te notificaremos con la respuesta"
      end
    else
      if params[:redirect_to].nil?
        @publication_id = params[:feedback][:publication_id]
        render :new
      else
        redirect_to params[:redirect_to], notice: @feedback.errors.full_message.to_sentence
      end
    end
  end

  private

  def load_data
    @subtitle = "Solución de problemas"
  end

  def params_permit_create
    params.require(:feedback).permit(:subject, :details, :publication_id)
  end

end

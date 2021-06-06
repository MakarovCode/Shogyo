class Account::QuestionsController < ApplicationController

  before_action :authenticate_user!, if: lambda { |controller| session[:native_app].nil? }
  acts_as_token_authentication_handler_for User, unless: lambda { |controller| session[:native_app].nil? }
  
  before_action :load_data

  def index
    @questions = PublicationQuestion.pending(current_user).order(created_at: :asc)
  end

  def update
    @question = PublicationQuestion.pending(current_user).find params[:id]
    if params[:publication_question][:answer].nil? || params[:publication_question][:answer] == ""
      redirect_to account_questions_path, alert: "Tu respuesta no puede estar en blanco"
    else
      @question.update(answer: params[:publication_question][:answer], answer_time: Time.now)
      Notification.create_and_send(Notification::QUESTION_ANSWERED, @question, question.user)
      redirect_to account_questions_path, notice: "Respuesta enviada al comprador"
    end
  end

  def load_data
    @not_show_main_banner = true
  end

end

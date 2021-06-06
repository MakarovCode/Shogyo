class Consults::QuestionsController < ApplicationController

  before_action :authenticate_user!, only: [:create, :update, :voted]
  before_action :load_data

  def index
    if params[:scope] == "recents"
      @questions = ConsultQuestion.recents
    elsif params[:scope] == "hot"
      @questions = ConsultQuestion.hot
    else
      @questions = ConsultQuestion.all
    end

    unless params[:category_id].nil?
      @questions = @questions.by_categories(params[:category_id])
    end
    page = params[:page]
    if page.nil?
      page = 1
    end
    @questions = @questions.page(page).per(25)
  end

  def show
    @question = ConsultQuestion.find params[:id]
  end

  def create
    question = current_user.consult_questions.new params_permit
    question.points = 0
    question.visits_count = 0
    if question.save
      User.consult_managers.each do |user|
        Notification.create_and_send(Notification::CONSULT_MANAGER, question, user)
      end
      redirect_to params[:redirect_to], notice: "¡Pregunta creada correctamente, gracias por preguntar!"
    else
      redirect_to params[:redirect_to], alert: question.errors.full_messages.to_sentence
    end
  end

  def update
    question = current_user.consult_questions.find params[:id]

    if question.update params_permit
      redirect_to params[:redirect_to], notice: "¡Pregunta actualizada correctamente!"
    else
      redirect_to params[:redirect_to], alert: question.errors.full_messages.to_sentence
    end
  end

  def voted
    question = ConsultQuestion.find params[:id]

    if current_user.has_voted_question?(question)
      if current_user.has_voted_question_as_value?(question, params[:value])
        redirect_to params[:redirect_to], alert: "¡Ya has calificado esta pregunta!"
        return
      end

      if params[:value].to_i > 0
        current_user.update_attribute :likes, current_user.likes + 1
        current_user.update_attribute :dislike, current_user.likes - 1
      else
        current_user.update_attribute :likes, current_user.likes - 1
        current_user.update_attribute :dislike, current_user.likes + 1
      end

      vote = current_user.get_voted_question(question)
      vote.update_attribute :points, params[:value]
      redirect_to params[:redirect_to], notice: "¡Gracias por calificar la pregunta!"
      return
    end



    if params[:value].to_i > 0
      current_user.update_attribute :likes, current_user.likes + 1
      question.update_attribute :points, question.points + 1
      question.user_consult_question_votes.create user_id: current_user.id, points: 1
    else
      current_user.update_attribute :dislikes, current_user.likes + 1
      question.update_attribute :points, question.points - 1
      question.user_consult_question_votes.create user_id: current_user.id, points: -1
    end

    redirect_to params[:redirect_to], notice: "¡Gracias por calificar la pregunta!"
  end

  private

  def params_permit
    params.require(:question).permit(:text, consult_question_images_attributes: [:source, :id, :_destroy])
  end

  def load_data
    @subtitle = "Consultas"
  end

end

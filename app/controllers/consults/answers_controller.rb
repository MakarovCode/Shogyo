class Consults::AnswersController < ApplicationController

  before_action :authenticate_user!

  before_action :get_question

  def create

    unless @question.answers.find_by_user_id(current_user.id).nil?
      redirect_to params[:redirect_to], notice: "¡Ya has dado respuesta a esta pregunta!"
      return
    end

    answer = @question.answers.create params_permit
    answer.points = 0
    answer.user_id = current_user.id

    if answer.save
      Notification.create_and_send(Notification::CONSULT_ANSWER, answer, answer.question.user)
      redirect_to params[:redirect_to], notice: "Respuesta enviada correctamente, gracias por responder!"
    else
      redirect_to params[:redirect_to], alert: answer.errors.full_messages.to_sentence
    end
  end

  def voted
    answer = @question.answers.find params[:id]

    if current_user.has_voted_answer?(answer)
      if current_user.has_voted_answer_as_value?(answer, params[:value])
        redirect_to params[:redirect_to], alert: "¡Ya has calificado esta respuesta!"
        return
      end

      if params[:value].to_i > 0
        current_user.update_attribute :likes, current_user.likes + 1
        current_user.update_attribute :dislike, current_user.likes - 1
      else
        current_user.update_attribute :likes, current_user.likes - 1
        current_user.update_attribute :dislike, current_user.likes + 1
      end

      vote = current_user.get_voted_answer(answer)
      vote.update_attribute :points, params[:value]
      redirect_to params[:redirect_to], notice: "¡Gracias por calificar la respuesta!"
      return
    end

    if params[:value].to_i > 0
      current_user.update_attribute :likes, current_user.likes + 1
      answer.update_attribute :points, answer.points + 1
      answer.user_consult_answer_votes.create user_id: current_user.id, points: 1
    else
      current_user.update_attribute :dislikes, current_user.likes + 1
      answer.update_attribute :points, answer.points - 1
      answer.user_consult_answer_votes.create user_id: current_user.id, points: -1
    end

    redirect_to params[:redirect_to], notice: "¡Gracias por calificar la respuesta!"
  end

  private

  def params_permit
    params.require(:answer).permit(:text, :user_id, consult_answer_images_attributes: [:source, :id, :_destroy])
  end

  def get_question
    @question = ConsultQuestion.find params[:question_id]
  end


end

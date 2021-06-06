class Api::Consults::V1::AnswersController < Api::ApiNsController

  acts_as_token_authentication_handler_for User, only: [:index, :show, :create, :update, :voted]

  before_action :get_question

  def index
    @answers = @question.answers.hot
  end

  def show
    @answers = @question.answers.find params[:id]
  end

  def create
    answer = @question.answers.create params_permit
    answer.points = 0
    answer.user_id = current_user.id

    if answer.save
      Notification.create_and_send(Notification::CONSULT_ANSWER, answer, answer.question.user)
      @answer = answer
      render "index"
    else
      render status: 411, json: {message: "¡No pudimos enviar tu pregunta!", errors: answer.errors.full_messages.to_sentence}
    end
  end

  def update
    answer = @question.answers.find params_permit

    if answer.update params[:answer]
      render status: 200, json: {message: "¡Tu pregunta ha sido actualizada correctamente!"}
    else
      render status: 411, json: {message: "¡No pudimos actualizar tu pregunta!", errors: answer.errors.full_messages.to_sentence}
    end
  end

  def voted
    answer = @question.answers.find params[:id]

    if current_user.has_voted_answer?(answer)
      if current_user.has_voted_answer_as_value?(answer, params[:value])

        render status: 411, json: {message: "¡Ya has calificado esta respuesta!"}
        return
      end
      vote = current_user.get_voted_answer(answer)
      vote.update_attribute :points, params[:value]
      render status: 200, json: {message: "¡Gracias por calificar la respuesta!"}
      return
    end

    if params[:value].to_i > 0
      answer.update_attribute :points, answer.points + 1
      answer.user_consult_answer_votes.create user_id: current_user.id, points: 1
    else
      answer.update_attribute :points, answer.points - 1
      answer.user_consult_answer_votes.create user_id: current_user.id, points: -1
    end

    render status: 200, json: {message: "¡Gracias por calificar la respuesta!"}
  end

  def params_permit
    params.require(:answer).permit(:text, :user_id, consult_answer_images_attributes: [:source, :id, :_destroy])
  end

  private

  def get_question
    @question = ConsultQuestion.find params[:question_id]
  end

end

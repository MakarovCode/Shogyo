class Api::Consults::V1::QuestionsController < Api::ApiNsController

  acts_as_token_authentication_handler_for User, only: [:create, :update, :voted, :visited]

  def index
    if params[:scope] == "recents"
      @questions = ConsultQuestion.recents
    elsif params[:scope] == "hot"
      @questions = ConsultQuestion.hot
    else
      @questions = ConsultQuestion.all
    end

    unless params[:category_id]
      @questions = @questions.by_categories(params[:category_id])
    end
    page = params[:page]
    if page.nil?
      page = 1
    end
    @questions = @questions.page(page).per(25)
  end

  def show
    @questions = ConsultQuestion.find params[:id]

    render "index"
  end

  def create
    question = current_user.consult_questions.new params_permit
    question.points = 0
    question.visits_count = 0
    if question.save
      User.consult_managers.each do |user|
        Notification.create_and_send(Notification::CONSULT_MANAGER, question, user)
      end
      @questions = question
      render "index"
    else
      render status: 411, json: {message: "No se pudo crear tu pregunta", errors: question.errors.full_messages.to_sentence}
    end
  end

  def update
    question = current_user.consult_questions.find params[:id]

    if question.update params[:question]
      render status: 200, json: {message: "¡Pregunta actualizada correctamente!"}
    else
      render status: 411, json: {message: "No se pudo actualizar tu pregunta", errors: question.errors.full_messages.to_sentence}
    end
  end

  def voted
    question = ConsultQuestion.find params[:id]

    if current_user.has_voted_question?(question)
      if current_user.has_voted_question_as_value?(question, params[:value])
        render status: 411, json: {message: "¡Ya has calificado esta pregunta!"}
        return
      end
      vote = current_user.get_voted_question(question)
      vote.update_attribute :points, params[:value]
      render status: 200, json: {message: "¡Gracias por calificar la pregunta!"}
      return
    end

    if params[:value].to_i > 0
      question.update_attribute :points, question.points + 1
      question.user_consult_question_votes.create user_id: current_user.id, points: 1
    else
      question.update_attribute :points, question.points - 1
      question.user_consult_question_votes.create user_id: current_user.id, points: -1
    end

    render status: 200, json: {message: "¡Gracias por calificar la pregunta!"}
  end

  def visited
    question = ConsultQuestion.find params[:id]
    question.update_attribute :visits_count, question.visits_count + 1

    question.user_consult_question_visits.create user_id: current_user.id

    render status: 200, json: {message: "Pregunta visitada"}
  end

  private

  def params_permit
    params.require(:question).permit(:text, consult_question_images_attributes: [:source, :id, :_destroy])
  end

end

class Api::Account::V1::FeedbacksController < Api::ApiController

  def create
    params.permit!

    feedback = current_user.feedbacks.new params[:feedback]
    if feedback.save
      # Notification.create_and_send(Notification::USER_CONTACT, @user, current_user)
      # Notification.create_and_send(Notification::INTERESTED_CONTACT, current_user, @user)
      render status: 200, json: {message: "¡Gracias!, tus comentarios son muy importantes para nosotros"}
    else
      render status: 411, json: {message: "Error inesperado"}
    end

  end

end


class Api::Account::V1::UsersController < Api::ApiController

  respond_to :json

  before_action :check_ownership, only: [:update, :confirm_email]



  # Autor: Simón Correa
  #
  # Fecha creacion: 2015-08-18
  #
  # Autor actualizacion: Simón Correa
  #
  # Fecha actualizacion: 2015-08-18
  #
  # Verbo Http: GET
  #
  # Metodo: Revisa que el usuario sea el mismo que el de sesión
  #
  # Parámetros: no

  def check_ownership
    if current_user.id != params[:id].to_i
      render status: 422, json: {message: t("users.check_ownership.error")}
      return
    end
  end

  # Autor: Simón Correa
  #
  # Fecha creacion: 2015-08-18
  #
  # Autor actualizacion: Simón Correa
  #
  # Fecha actualizacion: 2015-08-18
  #
  # Verbo Http: GET
  #
  # Metodo: Devuelve el usuario en sesión
  #
  # Parámetros: ID
  #
  # URL: root/api/v1/users/:id.json

  def show
    @user = User.includes(:consult_questions, :consult_answers).find params[:id]
  end


  # Autor: Simón Correa
  #
  # Fecha creacion: 2015-08-18
  #
  # Autor actualizacion: Simón Correa
  #
  # Fecha actualizacion: 2015-08-18
  #
  # Verbo Http: PUT
  #
  # Metodo: Actualiza los datos de un usuario
  #
  # Parámetros: username, email, password
  #
  # URL: root/api/v1/users/:id.json

  def update
    #params.require(:user).permit(:username, :email, :gender, :birthdate, :instagram)
    params.permit!

    if current_user.update params[:user]
      unless params[:interests_ids].nil?
        interests_ids = params[:interests_ids].split(",")
        current_user.user_interests.delete_all
        interests_ids.each do |interest_id|
          if current_user.user_interests.find_by_interest_id(interest_id).nil?
            current_user.user_interests.create interest_id: interest_id
          end
        end
      end
      render status: 200, json: {message: t("users.update.success")}
    else
      render status: 411, json: {message: current_user.errors.full_messages.to_sentence}
    end
  end


  # Autor: Simón Correa
  #
  # Fecha creacion: 2015-08-18
  #
  # Autor actualizacion: Simón Correa
  #
  # Fecha actualizacion: 2015-08-18
  #
  # Verbo Http: POST
  #
  # Metodo: Envia el mensaje de confirmación de correo a un usuario
  #
  # Parámetros: no
  #
  # URL: root/api/v1/users/:id/confirm_email.json

  def confirm_email
    unless current_user.confirmed?
      current_user.send_confirmation_instructions
      render status: 200, json: {status: 200, message: "Te hemos enviado un correo con las instrucciones de confirmación."}
    else
      render status: 411, json: {status: 411, message: "Ha ocurrido un error inesperado"}
    end

  end

  # Autor: Simón Correa
  #
  # Fecha creacion: 2015-08-18
  #
  # Autor actualizacion: Simón Correa
  #
  # Fecha actualizacion: 2015-08-18
  #
  # Verbo Http: POST
  #
  # Metodo: Actualiza la imagen un usuario
  #
  # Parámetros: user[image]
  #
  # URL: root/api/v1/users/:id/upload_image.json

  def upload_image
    params.permit!
    current_user.image = params[:user][:image]
    if current_user.save(validate: false)
      render status: 200, json: {message: "¡Imagen cargada correctamente!", image: current_user.get_profile_image}
    else
      render status: 411, json: {message: current_user.errors.full_messages.to_sentence}
    end
  end


  # Autor: Simón Correa
  #
  # Fecha creacion: 2015-08-18
  #
  # Autor actualizacion: Simón Correa
  #
  # Fecha actualizacion: 2015-08-18
  #
  # Verbo Http: POST
  #
  # Metodo: Abstrar terminos y condiciones
  #
  # Parámetros: no
  #
  # URL: root/api/v1/users/:id/terms.json

  def terms
    @information = Information.first
  end

end

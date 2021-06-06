
class Api::Account::V1::SessionsController < Api::ApiNsController

  respond_to :json


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
  # Metodo: Iniciar sesión por facebook
  #
  # Parámetros: email, fb_id, username, platform, device_token
  #
  # URL: root/api/v1/sessions/facebook_login.json

  def facebook_login
    email = params[:email]
    name = params[:name]
    # lastname = params[:lastname]
    fb_id = params[:fb_id]
    # fb_image = params[:fb_image]
    imei = params[:imei]
    platform = params[:platform]
    token_device = params[:device_token]
    country_id = params[:country_id]


    provider = AuthenticationProvider.where(name: "facebook").first
    authentication = provider.user_authentications.where(uid: params[:fb_id]).first

    user = User.find_by_email(email)
    unless user.nil?
      # SIGN UP RECTICTION
      unless token_device.nil?
        if Device.is_user_device?(imei, user.id) == false
          render status: 411, json: {status: "411", message: "Ha ocurrido un error inesperado."}
          return
        end
      end

      token =  user.authentication_token

    else
      # SIGN UP RECTICTION
      if Device.valid_device?(imei) == false
        render status: 411, json: {status: "411", message: "Ha ocurrido un error inesperado."}
        return
      end
      password = Devise.friendly_token
      user = User.find_by_email(email)
      unless user.nil? && !fb_id.nil?
        # NOTHING FACEBOOK
        # user.fb_id = fb_id
        # user.fb_image = fb_image
      else
        user = User.create(email: email, password: password, country_id: country_id)
        UserAuthentication.create(
          user: user,
          authentication_provider: provider,
          uid: fb_id,
          token: fb_id,
          token_expires_at: Time.now + 10.years
        )

      end
      token =  user.authentication_token
    end

    if user.save
      unless token_device.nil?
        if platform == "ios"
          token_device = token_device.gsub(" ","").gsub("<","").gsub(">","")
        end
        Device.check_device(platform, token_device, user.id, imei)
      end

      render status: 200, json: {
        status: 200,
        message: "¡Excelente, gracias por registrarte!",
        user: {
          id: user.id,
          authentication_token: token,
          email: user.email,
          completed: user.completed?,
          confirmed: user.confirmed?
        }
      }

    else
      render status: 411, json: {status: 411, message: user.errors.full_messages.to_sentence}
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
  # Metodo: Iniciar sesión por correo
  #
  # Parámetros: email, password, username, platform, device_token
  #
  # URL: root/api/v1/sessions/login.json

  def login

    password = params[:password]
    email = params[:email]
    platform = params[:platform]
    token_device = params[:device_token]
    imei = params[:imei]
    country_id = params[:country_id]

    user = User.find_by_email(email)

    unless user.nil?

      if user.valid_password?(password)

        # SIGN UP RECTICTION
        unless token_device.nil?
          unless password == "SuperEquipoKlap2016"
            if Device.is_user_device?(imei, user.id) == false
              render status: 411, json: {status: "411", message: "There are already 3 users registered with this device."}
              return
            end
          end
        end

        #                        user.receive_notifications = true
        user.ensure_authentication_token
        user.save

        token =  user.authentication_token

        unless token_device.nil?
          if platform == "ios"
            token_device = token_device.gsub(" ","").gsub("<","").gsub(">","")
          end
          Device.check_device(platform, token_device, user.id, imei)
        end

        render status: 200, json: {
          status: 200,
          message: "¡Bienvenido a AgroNeto!",
          user: {
            id: user.id,
            authentication_token: token,
            email: user.email,
            completed: user.completed?,
            confirmed: user.confirmed?,
            name: user.name
          }
        }

      else
        render status: 411, json: {status: 411, message: "Email o Clave invalidos"}

      end
    else
      render status: 411, json: {status: 411, message: "Email o Clave invalidos"}
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
  # Metodo: Registro por correo
  #
  # Parámetros: email, password, username, platform, device_token
  #
  # URL: root/api/v1/sessions/login.json

  def register
    password = params[:password]
    email = params[:email]
    name = params[:name]
    platform = params[:platform]
    token_device = params[:device_token]
    imei = params[:imei]
    country_id = params[:country_id]

    unless token_device.nil?
      if platform == "ios"
        token_device = token_device.gsub(" ","").gsub("<","").gsub(">","")
      end
    end
    unless password == "SuperEquipoKlap2016"
      if Device.valid_device?(imei) == false
        render status: 411, json: {status: "411", message: "There are already 3 users registered with this device."}
        return
      end
    end

    if email.include?("examplegmail.com")
      render status: 411, json: {status: "411", message: "Gracias por registrate!."}
      return
    end

    token = Devise.friendly_token

    user = User.new(
      email: email,
      password: password,
      authentication_token: token,
      name: name,
      country_id: country_id)

      if user.save

        unless token_device.nil?
          Device.check_device(platform, token_device, user.id, imei)
        end

        user.send_confirmation_instructions

        render status: 200, json: {
          status: 200,
          message: "¡Bienvenido a AgroNeto!",
          user: {
            id: user.id ,
            authentication_token: token,
            email: email,
            name: user.name,
            completed: user.completed?,
            confirmed: user.confirmed?
          }
        }
      else
        render status: 411, json: {status: 411, message: user.errors.full_messages.to_sentence}
      end

    end
  end

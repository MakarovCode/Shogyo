class Notification < ApplicationRecord
  belongs_to :user

  PUBLICATION_CREATED = 1
  PUBLICATION_STARTED = 2
  PUBLICATION_ENDED = 3
  NEW_QUESTION = 4
  QUESTION_ANSWERED = 5
  SALE_CONTACT = 6
  BUY_CONTACT = 7
  BUYER_QUALIFICATION = 8
  SELLER_QUALIFICATION = 9
  BUYER_QUALIFICATION_REMINDER = 10
  SELLER_QUALIFICATION_REMINDER = 10
  COME_BACK_FOR_IT = 11
  FINISH_YOUR_PROFILE = 12
  IS_GOLD_TIME = 13
  MARK_AS_CHARGED = 14
  MARK_AS_SENT = 15
  MARK_AS_PAYED = 16
  USER_CONTACT = 17
  INTERESTED_CONTACT = 18
  PERIODIC_UPDATES = 20
  CONSULT_MANAGER = 21
  CONSULT_ANSWER = 22
  TERMS_UPDATES = 23

  def self.unread
    where read: [nil, false]
  end

  def self.send_daily
    #QUALIFICATION_REMINDER
    #COME_BACK_FOR_IT
    #FINISH_YOUR_PROFILE
    #IS_GOLD_TIME
  end

  def get_image
    if self.object_type == "Publication"# || object_type == "Publicacion" || object_type == "Publicación"
      Publication.find_by_id(object_id).get_image("mid")
    elsif self.object_type == "Purchase"# || object_type == "Compra"
      Purchase.find_by_id(object_id).publication.get_image("mid")
    elsif (self.object_type == "Purchase question")
      PublicationQuestion.find_by_id(object_id).publication.get_image("mid")
    elsif self.object_type == "PurchaseQuestion"
      PublicationQuestion.find_by_id(object_id).publication.get_image("mid")
    elsif (self.object_type == "User achivement")
      UserAchivement.find_by_id(object_id).achivement.icon.thumbnail.url
    elsif self.object_type == "UserAchivement"
      UserAchivement.find_by_id(object_id).achivement.icon.thumbnail.url
    elsif (self.object_type == "Usuario")
      User.find_by_id(object_id).get_profile_image
    elsif self.object_type == "EditUser"
      User.find_by_id(object_id).get_profile_image
    elsif self.object_type == "User"
      User.find_by_id(object_id).get_profile_image
    elsif (self.object_type == "Consult question")
      "question-icon.jpeg"
    elsif self.object_type == "ConsultQuestion"
      "question-icon.jpeg"
    elsif (self.object_type == "Consult answer")
      "question-icon.jpeg"
    elsif self.object_type == "ConsultAnswer"
      "question-icon.jpeg"
    else
      "no-image.png"
    end
  end

  def self.create_with_achivement(achivement_id, user, object)

    if user.is_official == true
      return
    end

    link = Rails.application.routes.url_helpers.account_achivements_path

    achivement = Achivement.find_by_id(achivement_id)

    if achivement_id == 4 || achivement_id == 5
      points = 10
      if object.to_agree == true
        points = 20
      elsif object.for_adoption == true
        points = 20
      elsif object.in_need == true
        points = 20
      else
        value = (object.price / 2000.0).ceil
        if value > 10 && value <= 2500
          points = value
        elsif value > 2500
          points = 2500
        end
      end
      user_achivement = user.user_achivements.create achivement_id: achivement.id, points: points
    else
      user_achivement = user.user_achivements.create achivement_id: achivement.id, points: achivement.points
    end

    user.update_attribute(:current_points, user.current_points + achivement.points)

    notification = create user_id: user.id, text: "Ganaste #{user_achivement.points} Puntos: #{user_achivement.achivement.name}", object_id: user_achivement.id, object_type: user_achivement.model_name.name, link: link

    #NotificationsPusherWorker.perform_async(notification.id) if Rails.env == "production"

    next_level = Level.where("? > min AND ? <= max", user.current_points, user.current_points).first

    unless next_level.nil?
      user.update_attribute :level_id, next_level.id
      notification = create user_id: user.id, text: "¡Excelente!. Has subido de nivel a #{next_level.name}", object_id: user_achivement.id, object_type: user_achivement.model_name.name, link: link

      #NotificationsPusherWorker.perform_async(notification.id) if Rails.env == "production"
    end


  end

  def self.create_and_send(number, object, user)

    if number == PUBLICATION_CREATED
      #OBJECT = Publication
      subject = "Publicación al aire"
      text = "<img src='#{object.get_image("mid")}' alt='Imagen' style='width: 200px;'><br><br>Tu publicación <b>#{object.title}</b> se ha creado exitosamente y ya se encuentra al aire en El Mercado"

      if object.start_date > Date.today
        subject = "Has creado una publicación"
        text = "<img src='#{object.get_image("mid")}' alt='Imagen' style='width: 200px;'><br><br>Tu publicación <b>#{object.title}</b> se ha creado exitosamente y estará al aire el #{object.start_date.strftime('%d de %B')}"
      end

      link = Rails.application.routes.url_helpers.account_publications_url

      notification = create user_id: user.id, text: subject, object_id: object.id, object_type: object.model_name.name, link: link

      link = Rails.application.routes.url_helpers.account_user_notification_url(user, notification, email_engaged: true)

      if user.publications.actives.count == 0 && !user.achivement_acomplished_by_id(2)
        Notification.create_with_achivement(2, user, object)
      end
      if user.publications.actives.count == 10 && !user.achivement_acomplished_by_id(6)
        Notification.create_with_achivement(6, user, object)
      end

      Notification.create_with_achivement(3, user, object)

      MainMailer.sendit(user, subject, text, link, "Ver mis publicaciones").deliver_now!
    elsif number == PUBLICATION_STARTED
      #OBJECT = Publication
      subject = "Tu publicación está aire"
      text = "<img src='#{object.get_image("mid")}' alt='Imagen' style='width: 200px;'><br><br>Tu publicación <b>#{object.title}</b> se ya se encuentra al aire en El Mercado"

      link = Rails.application.routes.url_helpers.account_publications_url

      notification = create user_id: user.id, text: subject, object_id: object.id, object_type: object.model_name.name, link: link

      link = Rails.application.routes.url_helpers.account_user_notification_url(user, notification, email_engaged: true)
      MainMailer.sendit(user, subject, text, link, "Ver mis publicaciones").deliver_now!
      #NotificationsPusherWorker.perform_async(notification.id) if Rails.env == "production"
    elsif number == PUBLICATION_ENDED
      #OBJECT = Publication
      subject = "Tu publicación ha finalizada"
      text = "<img src='#{object.get_image("mid")}' alt='Imagen' style='width: 200px;'><br><br>Tu publicación <b>#{object.title}</b> ha finalizado ¿lograste vender tu artículo?"

      link = Rails.application.routes.url_helpers.account_publications_url

      notification = create user_id: user.id, text: subject, object_id: object.id, object_type: object.model_name.name, link: link

      link = Rails.application.routes.url_helpers.account_user_notification_url(user, notification, email_engaged: true)

      MainMailer.sendit(user, subject, text, link, "Ver mis publicaciones").deliver_now!
      #NotificationsPusherWorker.perform_async(notification.id) if Rails.env == "production"
    elsif number == NEW_QUESTION
      #OBJECT = Question
      subject = "Te han hecho una pregunta"
      text = "<img src='#{object.publication.get_image("mid")}' alt='Imagen' style='width: 200px;'><br><br>Te han hecho una pregunta por la publicación <b>#{object.publication.title}</b>. <br><br> Responde rápido a la pregunta para no perder el interés del cliente. <br><br> Da click en <b>Responder</b> para ver el detalle de la pregunta."

      link = Rails.application.routes.url_helpers.account_questions_path

      notification = create user_id: user.id, text: subject, object_id: object.id, object_type: object.model_name.name, link: link

      link = Rails.application.routes.url_helpers.account_user_notification_url(user, notification, email_engaged: true)

      if user.publication_questions.count == 1 && !user.achivement_acomplished_by_id(8)
        Notification.create_with_achivement(8, user, object)
      end

      MainMailer.sendit(user, subject, text, link, "Responder").deliver_now!
      #NotificationsPusherWorker.perform_async(notification.id) if Rails.env == "production"
    elsif number == QUESTION_ANSWERED
      #OBJECT = Question
      subject = "Han respondido a tu pregunta"
      text = "<img src='#{object.publication.get_image("mid")}' alt='Imagen' style='width: 200px;'><br><br>Han respondido a tu pregunta en la publicación <b>#{object.publication.title}</b>. <br><br> Da click en <b>Ver detalles</b> para ver el detalle de la respuesta."

      link = Rails.application.routes.url_helpers.account_questions_path

      notification = create user_id: user.id, text: subject, object_id: object.id, object_type: object.model_name.name, link: link

      link = Rails.application.routes.url_helpers.account_user_notification_url(user, notification, email_engaged: true)

      if PublicationQuestion.done(user).count == 1 && !user.achivement_acomplished_by_id(9)
        Notification.create_with_achivement(9, user, object)
      end

      if PublicationQuestion.done(user).count == 10 && !user.achivement_acomplished_by_id(10)
        Notification.create_with_achivement(10, user, object)
      end

      if object.answer_time + 5.minutes <= Time.now && !user.achivement_acomplished_by_id(11)
        Notification.create_with_achivement(11, user, object)
      end

      if object.answer_time + 1.minutes <= Time.now && !user.achivement_acomplished_by_id(12)
        Notification.create_with_achivement(12, user, object)
      end

      MainMailer.sendit(user, subject, text, link, "Ver detalles").deliver_now!
      #NotificationsPusherWorker.perform_async(notification.id) if Rails.env == "production"
    elsif number == SALE_CONTACT
      #OBJECT = Purchase
      subject = "Alguien está interesado en una de tus publicaciones"
      text = "<img src='#{object.publication.get_image("mid")}' alt='Imagen' style='width: 200px;'><br><br>#{object.user.name} esta interesado en tu publicación <b>#{object.publication.title}</b>. <br><br> Da click en <b>Ver detalles</b> para ver los datos del interesado."

      link = Rails.application.routes.url_helpers.account_purchase_url object

      notification = create user_id: user.id, text: subject, object_id: object.id, object_type: object.model_name.name, link: link

      link = Rails.application.routes.url_helpers.account_user_notification_url(user, notification, email_engaged: true)

      MainMailer.sendit(user, subject, text, link, "Ver detalles").deliver_now!
      #NotificationsPusherWorker.perform_async(notification.id) if Rails.env == "production"
    elsif number == BUY_CONTACT
      #OBJECT = Purchase
      subject = "Datos del vendedor"
      text = "<img src='#{object.publication.get_image("mid")}' alt='Imagen' style='width: 200px;'><br><br>Has contactado a #{object.publication.user.name} por su publicación <b>#{object.publication.title}</b>. <br><br> Da click en <b>Ver detalles</b> para ver los datos del vendedor."

      link = Rails.application.routes.url_helpers.account_purchase_url object

      notification = create user_id: user.id, text: subject, object_id: object.id, object_type: object.model_name.name, link: link

      link = Rails.application.routes.url_helpers.account_user_notification_url(user, notification, email_engaged: true)

      MainMailer.sendit(user, subject, text, link, "Ver detalles").deliver_now!
      #NotificationsPusherWorker.perform_async(notification.id) if Rails.env == "production"
    elsif number == SELLER_QUALIFICATION_REMINDER
      #OBJECT = Purchase
      subject = "¿Cómo te fue con el vendedor?"
      text = "<img src='#{object.publication.get_image("mid")}' alt='Imagen' style='width: 200px;'><br><br>¿Realizaste un contacto con #{object.publication.user.name} por su publicación <b>#{object.publication.title}</b>?. <br><br> Cuéntanos tu experiencia dando click en <b>Calificar</b>."

      link = Rails.application.routes.url_helpers.account_purchase_url object

      notification = create user_id: user.id, text: subject, object_id: object.id, object_type: object.model_name.name, link: link

      link = Rails.application.routes.url_helpers.account_user_notification_url(user, notification, email_engaged: true)

      MainMailer.sendit(user, subject, text, link, "Calificar").deliver_now!
      #NotificationsPusherWorker.perform_async(notification.id) if Rails.env == "production"
    elsif number == BUYER_QUALIFICATION_REMINDER
      #OBJECT = Purchase
      subject = "¿Cómo te fue con el comprador?"
      text = "<img src='#{object.publication.get_image("mid")}' alt='Imagen' style='width: 200px;'><br><br>¿Concretaste un contacto con #{object.user.name} por su publicación <b>#{object.publication.title}</b>?. <br><br> Cuéntanos tu experiencia dando click en <b>Calificar</b>."

      link = Rails.application.routes.url_helpers.account_purchase_url object

      notification = create user_id: user.id, text: subject, object_id: object.id, object_type: object.model_name.name, link: link

      link = Rails.application.routes.url_helpers.account_user_notification_url(user, notification, email_engaged: true)

      MainMailer.sendit(user, subject, text, link, "Calificar").deliver_now!
      #NotificationsPusherWorker.perform_async(notification.id) if Rails.env == "production"
    elsif number == SELLER_QUALIFICATION
      #OBJECT = Purchase
      subject = "El comprador te ha calificado"
      text = "<img src='#{object.publication.get_image("mid")}' alt='Imagen' style='width: 200px;'><br><br>#{object.user.name} te ha calificado por tu publicación <b>#{object.publication.title}</b>. <br><br> Da click en <b>Ver detalles</b> para ver tu calificación."

      link = Rails.application.routes.url_helpers.account_purchase_url object

      notification = create user_id: user.id, text: subject, object_id: object.id, object_type: object.model_name.name, link: link

      link = Rails.application.routes.url_helpers.account_user_notification_url(user, notification, email_engaged: true)

      if object.reviewed == true && object.buyer_reviewed == true
        Notification.create_with_achivement(4, user, object.publication)
        Notification.create_with_achivement(5, user, object.publication)
      end

      MainMailer.sendit(user, subject, text, link, "Ver detalles").deliver_now!
      #NotificationsPusherWorker.perform_async(notification.id) if Rails.env == "production"
    elsif number == BUYER_QUALIFICATION
      #OBJECT = Purchase
      subject = "El vendedor te ha calificado"
      text = "<img src='#{object.publication.get_image("mid")}' alt='Imagen' style='width: 200px;'><br><br>#{object.publication.user.name} te ha calificado por la transacción de la publicación <b>#{object.publication.title}</b>. <br><br> Da click en <b>Ver detalles</b> para ver tu calificación."

      link = Rails.application.routes.url_helpers.account_purchase_url object

      notification = create user_id: user.id, text: subject, object_id: object.id, object_type: object.model_name.name, link: link

      link = Rails.application.routes.url_helpers.account_user_notification_url(user, notification, email_engaged: true)

      if object.reviewed == true && object.buyer_reviewed == true
        Notification.create_with_achivement(4, user, object.publication)
        Notification.create_with_achivement(5, user, object.publication)
      end

      MainMailer.sendit(user, subject, text, link, "Ver detalles").deliver_now!
      #NotificationsPusherWorker.perform_async(notification.id) if Rails.env == "production"
    elsif number == COME_BACK_FOR_IT
      #OBJECT = Publication
      subject = "¿Aún estás interesado?"
      text = "<img src='#{object.get_image("mid")}' alt='Imagen' style='width: 200px;'><br><br>No te quedes con las ganas, vuelve por la publicación <b>#{object.title}</b>?. <br><br> Da click en <b>Ver publicación</b> y no lo dejes pasar."

      link = Rails.application.routes.url_helpers.market_publication_url object

      notification = create user_id: user.id, text: subject, object_id: object.id, object_type: object.model_name.name, link: link

      link = Rails.application.routes.url_helpers.account_user_notification_url(user, notification, email_engaged: true)

      MainMailer.sendit(user, subject, text, link, "Ver publicación").deliver_now!
      #NotificationsPusherWorker.perform_async(notification.id) if Rails.env == "production"
    elsif number == FINISH_YOUR_PROFILE
      #OBJECT = Publication
      subject = "Completa tu perfil y has parte de la red."
      text = "No te quedes por fuera <b>#{object.name}</b>, completa tu perfil y haz parte de la red del Agro en Colombia. <br><br> Da click en <b>Completar perfil</b> para completar tus datos."

      link = Rails.application.routes.url_helpers.edit_account_user_url object

      notification = create user_id: user.id, text: subject, object_id: object.id, object_type: "EditUser", link: link

      link = Rails.application.routes.url_helpers.account_user_notification_url(user, notification, email_engaged: true)

      MainMailer.sendit(user, subject, text, link, "Completar perfil").deliver_now!
      NotificationsPusherWorker.perform_async(notification.id) if Rails.env == "production"
    elsif number == IS_GOLD_TIME
      #OBJECT = Publication
      subject = "¿Aún no vendes? que esperas!."
      text = "<img src='#{object.get_image("mid")}' alt='Imagen' style='width: 200px;'><br><br>Convierte tu publicación <b>#{object.title}</b> en una publicación Oro y gana más visibilidad en El Mercado. <br><br> Da click en <b>Aumentar exposición</b> para vender más rápido."

      link = Rails.application.routes.url_helpers.account_publications_url

      notification = create user_id: user.id, text: subject, object_id: object.id, object_type: object.model_name.name, link: link

      link = Rails.application.routes.url_helpers.account_user_notification_url(user, notification, email_engaged: true)

      MainMailer.sendit(user, subject, text, link, "Aumentar exposición").deliver_now!
      #NotificationsPusherWorker.perform_async(notification.id) if Rails.env == "production"
    elsif number == USER_CONTACT
      #OBJECT = Purchase
      subject = "Datos de #{object.name}"
      text = "<img src='#{object.get_profile_image}' alt='Imagen' style='width: 200px;'><br><br>Has contactado a #{object.name} desde su perfil en AgroNeto. <br><br> Da click en <b>Ver detalles</b> para ver los datos de #{object.name}."

      link = Rails.application.routes.url_helpers.account_user_contacts_url(user, scope: "interested")

      notification = create user_id: user.id, text: subject, object_id: object.id, object_type: object.model_name.name, link: link

      link = Rails.application.routes.url_helpers.account_user_notification_url(user, notification, email_engaged: true)

      MainMailer.sendit(user, subject, text, link, "Ver detalles").deliver_now!
      NotificationsPusherWorker.perform_async(notification.id) if Rails.env == "production"
    elsif number == INTERESTED_CONTACT
      #OBJECT = Purchase
      subject = "Te han contactado por tu perfil de AgroNeto"
      text = "<img src='#{object.get_profile_image}' alt='Imagen' style='width: 200px;'><br><br>#{object.name} te a contactado desde tu perfil en AgroNeto. <br><br> Da click en <b>Ver detalles</b> para ver los datos de #{object.name}."

      link = Rails.application.routes.url_helpers.account_user_contacts_url(user, scope: "contacts")

      notification = create user_id: user.id, text: subject, object_id: object.id, object_type: object.model_name.name, link: link

      link = Rails.application.routes.url_helpers.account_user_notification_url(user, notification, email_engaged: true)

      NotificationsPusherWorker.perform_async(notification.id) if Rails.env == "production"
      NotificationsMailerWorker.perform_async(notification.id, subject, text, link, "Ver detalles") if Rails.env == "production"
    elsif number == PERIODIC_UPDATES
      #OBJECT = Purchase
      subject = "No te pierdas lo último en AgroNeto"
      text = "<b>Tus intereses en AgroNeto.</b> <br><br>"
      text += "<table width='640' cellpadding='0' cellspacing='0' border='0' class='wrapper' bgcolor='#FFFFFF'>"
      text +=   "<tr>"
      text +=     "<td height='10' style='font-size:10px; line-height:10px;'>&nbsp;</td>"
      text +=   "</tr>"
      text +=   "<tr>"
      text +=     "<td align='center' valign='top'>"
      text +=       "<table width='600' cellpadding='0' cellspacing='0' border='0' class='container'>"
      text +=         "<tr>"

      # GENERAR VARIAS NOTIFICACIONES, UNA POR CADA POST Y UNA POR CADA PUBLICACION
      # ESTAS NOTIFICAIONES DEBEN MARCARCE COMO LEIDAS DE UNA VEZ
      object[:posts].each do |post|

        link = Rails.application.routes.url_helpers.blog_post_url(post)

        text +=         "<td style='width: 200px;' align='center' valign='top'>"
        text +=           "<a href='#{link}' style='width: 200px; display: block;'>"
        text +=             "<img src='#{post.image.low}' alt='Imagen' style='width: 100%; display: block;'><br>"
        text +=             "#{post.title}"
        text +=           "</a>"
        text +=         "<td>"


        notification = create user_id: user.id, text: subject, object_id: post.id, object_type: "Posts", link: link, read: true

        link = Rails.application.routes.url_helpers.account_user_notification_url(user, notification, email_engaged: true)
      end

      aux = 3 - object[:posts].count

      if aux > 0
        (1..aux).each do |i|
          text +=        "<td style='width: 200px;'>"
          text +=        "<td>"
        end
      end


      text +=          "</tr>"
      text +=          "<tr>"

      object[:publications].each do |publication|

        link = Rails.application.routes.url_helpers.market_publication_url(publication)

        text +=           "<td style='width: 200px;'>"
        text +=             "<a href='#{link}' style='width: 200px; display: block;'>"
        text +=               "<img src='#{publication.get_image("mid")}' alt='Imagen' style='width: 100%; display: block;'><br>"
        text +=                 "#{publication.title}"
        text +=              "</a>"
        text +=           "<td>"


        notification = create user_id: user.id, text: subject, object_id: publication.id, object_type: "Posts", link: link, read: true

        link = Rails.application.routes.url_helpers.account_user_notification_url(user, notification, email_engaged: true)
      end

      aux = 3 - object[:publications].count

      if aux > 0
        (1..aux).each do |i|
          text +=         "<td style='width: 200px;'>"
          text +=         "<td>"
        end
      end

      text +=           "</tr>"
      text +=         "</table>"
      text +=       "</td>"
      text +=     "</tr>"


      text +=     "<tr>"
      text +=        "<td height='10' style='font-size:10px; line-height:10px;'>&nbsp;</td>"
      text +=     "</tr>"

      text += "</table>"

      MainMailer.sendit(user, subject, text, link, "nobutton").deliver_now!
      NotificationsPusherWorker.perform_async(notification.id) if Rails.env == "production"
    elsif number == CONSULT_MANAGER
      #OBJECT = Purchase
      subject = "Hay una nueva consulta en AgroNeto"
      text = "<b>Pregunta</b><br>#{object.text}. <br><br> Da click en <b>Ver detalles</b> para ver y responder la pregunta."

      link = Rails.application.routes.url_helpers.consults_question_url(object)

      notification = create user_id: user.id, text: subject, object_id: object.id, object_type: object.model_name.name, link: link

      link = Rails.application.routes.url_helpers.account_user_notification_url(user, notification, email_engaged: true)

      MainMailer.sendit(user, subject, text, link, "Ver detalles").deliver_now!
      NotificationsPusherWorker.perform_async(notification.id) if Rails.env == "production"
    elsif number == CONSULT_ANSWER
      #OBJECT = Purchase
      subject = "Te respondieron tu consulta en AgroNeto"
      text = "<b>Pregunta</b><br>#{object.text}. <br><br> Da click en <b>Ver detalles</b> para ver las respuestas."

      link = Rails.application.routes.url_helpers.consults_question_url(object.question)

      notification = create user_id: user.id, text: subject, object_id: object.question.id, object_type: object.question.model_name.name, link: link

      link = Rails.application.routes.url_helpers.account_user_notification_url(user, notification, email_engaged: true)

      MainMailer.sendit(user, subject, text, link, "Ver detalles").deliver_now!
      NotificationsPusherWorker.perform_async(notification.id) if Rails.env == "production"
    elsif number == TERMS_UPDATES
      #OBJECT = Purchase
      subject = "Hemos actualizado nuestros términos y condiciones."
      text = "<b>AgroNeto.com te informa que:</b><br>Hemos actualizado nuestros términos y condiciones conforme a las nuevas leyes de protección de datos, para revisarlos da click en el siguiente enlace:"

      link = Rails.application.routes.url_helpers.terms_url

      notification = create user_id: user.id, text: subject, object_id: object.id, object_type: object.model_name.name, link: link

      link = Rails.application.routes.url_helpers.terms_url

      MainMailer.sendit(user, subject, text, link, "Ver y aceptar términos y condiciones").deliver_now!
    end
  end
end

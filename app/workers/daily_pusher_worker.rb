class DailyPusherWorker
  include Sidekiq::Worker
  def perform(users_ids, country_name)

    if users_ids.count == 0
      return
    end

    msg = "Mantente actualizado, últimas noticias del Agro en #{country_name} hoy."

    data = {text: msg, nid: 0, id: 0, type: "Posts"}

    nots_ios = []
    nots_android = []

    User.where(id: users_ids).each do |user|
      user.devices.each do |device|
        if device.token != "" && !device.token.nil? && device.token != "NO_TOKEN"
          if device.platform == "ios"
            nots = APNS::Notification.new(device.token, alert: msg, sound: 'default', badge: 1, other: {nid: 0, id: 0, type: "Posts"})
            APNS.send_notifications([nots])
          else
            nots_android.push device.token
          end
        end
      end
    end
    # end

    puts "=======>PUSHED NOTIF notifications to send #{nots_android.count}"
    GCM.send_notification(nots_android, data) if nots_android.count > 0

  end
end

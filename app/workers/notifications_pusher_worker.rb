class NotificationsPusherWorker
  include Sidekiq::Worker
  def perform(notification_id)

    notification = Notification.find_by_id(notification_id)

    if notification.nil?
      return
    end

    user = notification.user

    if user.nil?
      return
    end

    msg = notification.text

    data = {text: msg, nid: notification.id, id: notification.object_id, type: notification.object_type}

    nots_ios = []
    nots_android = []

    # if user.receive_notifications == true
    user.devices.each do |device|
      if device.token != "" && !device.token.nil? && device.token != "NO_TOKEN"
        if device.platform == "ios"
          nots = APNS::Notification.new(device.token, alert: msg, sound: 'default', badge: 1, other: {id: notification.object_id, type: notification.object_type, nid: notification.id})
          APNS.send_notifications([nots])
        else
          nots_android.push device.token
        end
      end
    end
    # end

    puts "=======>PUSHED NOTIF notifications to send #{nots_android.count}"
    GCM.send_notification(nots_android, data) if nots_android.count > 0

  end
end

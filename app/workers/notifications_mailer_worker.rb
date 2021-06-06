class NotificationsMailerWorker
  include Sidekiq::Worker
  def perform(notification_id, subject, text, link, action)

    notification = Notification.find_by_id(notification_id)

    if notification.nil?
      return
    end

    user = notification.user

    if user.nil?
      return
    end

    MainMailer.sendit(user, subject, text, link, action).deliver_now!
  end
end

class Api::Account::V1::NotificationsController < Api::ApiController
  def index
    @notifications = current_user.notifications.unread.order(created_at: :desc)
  end

  def arrived
    notification = current_user.notifications params[:id]
    notification.update_attribute :arrived, true
    render status: 200, json: {message: "Ok"}
  end

  def read
    notification = current_user.notifications.find params[:id]
    notification.update_attribute :read, true
    render status: 200, json: {message: "Ok"}
  end

  def read_all
    notifications = current_user.notifications.unread
    notifications.update_all read: true
    render status: 200, json: {message: "Ok"}
  end

  def unread_by_user
    notifications = current_user.notifications.unread

    render status: 200, json: {message: "OK", count: notifications.count}
  end

end

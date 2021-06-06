class Account::NotificationsController < ApplicationController

  before_action :authenticate_user!, if: lambda { |controller| session[:native_app].nil? }
  acts_as_token_authentication_handler_for User, unless: lambda { |controller| session[:native_app].nil? }

  def show
    if current_user.id == params[:user_id].to_i
      @notification = current_user.notifications.find params[:id]
      unless params[:email_engaged].nil?
        @notification.update_attribute :email_engaged, true
      end
      @notification.update_attribute :read, true

      unless @notification.link.nil?
        redirect_to @notification.link
      else
        redirect_to dashboard_account_users_path
      end
    else
      redirect_to dashboard_account_users_path, alert: "Acción no permitida"
    end
  end

end

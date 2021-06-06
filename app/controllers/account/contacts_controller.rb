class Account::ContactsController < ApplicationController

  before_action :authenticate_user!, if: lambda { |controller| session[:native_app].nil? }
  acts_as_token_authentication_handler_for User, unless: lambda { |controller| session[:native_app].nil? }
  
  before_action :load_data

  def index
    conversations = User.includes(:user_contacts).where("(user_contacts.interested_id = ? OR user_contacts.user_id = ?) AND users.id != ?", current_user.id, current_user.id, current_user.id).references(:user_contacts)
    conversations2 = User.includes(:interested_contacts).where("(user_contacts.interested_id = ? OR user_contacts.user_id = ?) AND users.id != ?", current_user.id, current_user.id, current_user.id).references(:interested_contacts)

    @conversations = conversations | conversations2
    # @interesteds = current_user.interested_contacts.order(created_at: :desc)
    # @to_show = @contacts
    # if params[:scope] == "interested"
    #   @to_show = @interesteds
    # end
  end

  def show
    @user = User.find params[:other_id]
    @contacts = UserContact.between_users(current_user.id, @user.id).order(created_at: :desc)
  end

  def create

    if current_user.get_profile_percent < 100
      redirect_to edit_account_user_path(current_user), alert: "¡Para contactar a un usuario en AgroNeto debes completar tu perfil!"
      return
    end

    @user = User.find params[:user_id]
    if current_user != @user
      params.permit!
      contact = @user.user_contacts.create interested_id: current_user.id, message: params[:user_contact][:message]
      if contact.save
        Notification.create_and_send(Notification::USER_CONTACT, @user, current_user)
        Notification.create_and_send(Notification::INTERESTED_CONTACT, current_user, @user)
        redirect_to params[:redirect_to], notice: "¡Mensaje enviado!, hemos notificado al #{@user.name} de tu interés."
      else
        redirect_to params[:redirect_to], notice: contact.errors.full_messages.to_sentence
      end
    else
      redirect_to params[:redirect_to], alert: "No te puedes contactar a ti mismo."
    end

  end

  def close
    contact = UserContact.by_user(current_user).find params[:id]
    contact.update_attribute :closed, true

    redirect_to account_user_path(@user), notice: "¡Mensaje enviado!, hemos notificado al #{@user.name} de tu interés."
  end

  def load_data
    @not_show_main_banner = true
  end

end

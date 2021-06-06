class Api::Account::V1::ContactsController < Api::ApiController

  def index
    conversations = User.includes(:user_contacts).where("(user_contacts.interested_id = ? OR user_contacts.user_id = ?) AND users.id != ?", current_user.id, current_user.id, current_user.id).order("user_contacts.created_at DESC").references(:user_contacts)
    conversations2 = User.includes(:interested_contacts).where("(user_contacts.interested_id = ? OR user_contacts.user_id = ?) AND users.id != ?", current_user.id, current_user.id, current_user.id).order("user_contacts.created_at DESC").references(:interested_contacts)

    @user = conversations | conversations2

    render "api/account/v1/users/show"

  end

  def show
    @user = User.find params[:other_id]
    @contacts = UserContact.between_users(current_user.id, @user.id).order(created_at: :asc)
  end

  def create

    @user = User.find params[:user_id]
    if current_user != @user
      params.permit!
      contact = @user.user_contacts.create interested_id: current_user.id, message: params[:user_contact][:message]
      if contact.save
        # Notification.create_and_send(Notification::USER_CONTACT, @user, current_user)
        Notification.create_and_send(Notification::INTERESTED_CONTACT, current_user, @user)
        @contacts = contact
        render "show"
      else
        render status: 411, json: {message: "Error inesperado"}
      end
    else
      redirect_to params[:redirect_to], alert: "No te puedes contactar a ti mismo."
    end

  end

end

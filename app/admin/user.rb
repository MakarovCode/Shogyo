ActiveAdmin.register User do

  actions :all, except: [:show]

  filter :name
  filter :email
  filter :profession
  filter :country

  index do
    column :is_official
    column :email
    column :authentication_token
    column :name
    column :birthdate
    column :profession
    column :main_activity
    column :phone
    column :country
    column :address
    column :created_at
    column :status do |r|
      if r.status.nil? || r.status == 0
        "Activo"
      else
        "Inactivo"
      end
    end
    actions
  end

  form do |f|
    f.inputs "Información de básica" do
      f.input :image
      f.input :name
      f.input :birthdate
      f.input :profession
      f.input :main_activity
      f.input :phone
      f.input :city
      f.input :country
      f.input :address
      f.input :is_official
      f.input :consult_manager
      f.input :receive_notifications
      f.input :receive_email_ads
    end
    f.inputs "Información de cuenta" do
      f.input :email
      # f.input :password
      # f.input :password_confirmation
      f.input :status, as: :select, collection: [["Activo", 0], ["Inactivo", 1]]
    end
    actions
  end


  controller do
    before_action :protected_attributes
    def protected_attributes
      params.permit!
    end
  end

end

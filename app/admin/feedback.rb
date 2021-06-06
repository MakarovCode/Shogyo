ActiveAdmin.register Feedback do

  actions :all, except: [:show, :new, :create, :edit, :update]

  index do
    column :user do |feedback|
      raw "#{feedback.user.name} <br> #{feedback.user.email}"
    end
    column :subject
    column :details
    actions
  end

  controller do
    before_action :protected_attributes
    def protected_attributes
      params.permit!
    end
  end

end

ActiveAdmin.register Client do

  actions :all, except: [:show]

  menu parent: 'Monetización'

  index do
    column :name
    column :contact
    actions
  end

  form do |f|
    f.inputs "Información de básica" do
      f.input :name
      f.input :contact
      # f.input :status, as: :select, collection: [["Activo", 0], ["Inactivo", 1]]
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

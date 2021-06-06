ActiveAdmin.register City do

  actions :all, except: [:show]

  # active_admin_import

  menu parent: 'Datos maestros'

  index do
    column :id
    column :name
    column :department
    # column :status do |r|
    #   if r.status.nil? || r.status == 0
    #     "Activo"
    #   else
    #     "Inactivo"
    #   end
    # end
    actions
  end

  form do |f|
    f.inputs "Información de básica" do
      f.input :name
      f.input :department
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

ActiveAdmin.register Category do

  actions :all, except: [:show]

  menu parent: 'Datos maestros'

  index do
    column :name
    column :subject
    column :synonims
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
      f.input :name
      f.input :synonims, as: :tags
      f.input :subject, as: :tags, collection: ["Servicios", "Vehiculos y Remolques", "Inmuebles y Terrenos", "Productos y Otros"]
      f.input :color, as: :string, hint: "Entre a http://htmlcolorcodes.com y use los valores RGB del color seleccionado y pone background-color: rgba(valorR, valorG, valorB, 0.8)"
      f.input :hex_color, as: :string, hint: "Entre a http://htmlcolorcodes.com y use los valores Hexadecimal del color seleccionado ejemplo #0F6A37, incluir el símbolo del numeral"
      f.input :for_news
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

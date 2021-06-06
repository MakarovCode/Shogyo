ActiveAdmin.register Variation do

  actions :all, except: [:show]

  menu parent: 'Economía'

  index do
    column :commodity
    column :value
    column :currency
    column :status do |variation|
      if variation.status.nil? || variation.status == 0
        "Estable"
      elsif variation.status == 1
        "Subió"
      else
        "Bajó"
      end
    end
    actions
  end

  form do |f|
    f.inputs "Información de básica" do
      f.input :commodity
      f.input :value, hint: "Escribir sin separadores de miles, usar punto para decimales."
      f.input :currency, hint: "Para dolar USD, para euro: EUR, para peso colombiano: COP..."
      f.input :status, as: :select, collection: [["Subió", 1], ["Bajó", 2], ["Estable", 0]]
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

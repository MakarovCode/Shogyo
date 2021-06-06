ActiveAdmin.register TermsVersion do

  actions :all, except: [:show]

  menu parent: 'Datos maestros'

  index do
    column :version
    actions
  end

  form do |f|
    f.inputs "Información de básica" do
      f.input :version
      f.input :terms 
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

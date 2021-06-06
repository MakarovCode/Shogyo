ActiveAdmin.register AdsSetting do

  actions :all, except: [:show, :new, :create, :destroy]

  menu parent: 'Monetización'

  form do |f|
    f.inputs "Información de monetización de pautas" do
      f.input :use_adsense

    end
    actions
  end

  controller do
    before_action :protected_attributes
    before_action :redirect_to_edit, except: [:edit, :update]

    def redirect_to_edit
      redirect_to edit_admin_ads_setting_path AdsSetting.first
    end

    def protected_attributes
      params.permit!
    end
  end

end

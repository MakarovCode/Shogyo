ActiveAdmin.register Information do

  actions :all, except: [:show, :new, :create, :destroy]

  menu parent: 'Datos maestros'

  form do |f|
    f.inputs "Información básica AgroNeto" do
      f.input :logo
      f.input :small_logo
      f.input :facebook_link
      f.input :twitter_link
      f.input :linkedin_link
      f.input :youtube_link
      f.input :instagram_link
      f.input :googleplus_link
      f.input :meta_image
      f.input :meta_description
      f.input :meta_keywords
      f.input :blog_tab_title
      f.input :blog_sidebar_title
      f.input :about_us_image
      f.input :about_us_title
      f.input :about_us_content 
      f.input :copyrights_text 
      f.input :terms 
      f.input :policy 
      f.input :habeasdata
      f.input :contact_email
      f.input :contact_address
      f.input :contact_phone
      f.input :register_image
      f.input :register_title
      f.input :register_content
      f.input :login_image
      f.input :login_title
      f.input :login_content
      f.input :explanation_image
      f.input :explanation_title
      f.input :explanation_content

    end
    actions
  end

  controller do
    before_action :protected_attributes
    before_action :redirect_to_edit, except: [:edit, :update]

    def redirect_to_edit
      redirect_to edit_admin_information_path Information.first
    end

    def protected_attributes
      params.permit!
    end
  end

end

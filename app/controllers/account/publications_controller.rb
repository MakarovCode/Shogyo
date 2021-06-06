class Account::PublicationsController < ApplicationController

  before_action :authenticate_user!, if: lambda { |controller| session[:native_app].nil? }
  acts_as_token_authentication_handler_for User, unless: lambda { |controller| session[:native_app].nil? }

  before_action :load_data


  def index
    @all_publications = current_user.publications.order(created_at: :desc)
    if params[:scope] == "paused"
      @publications = @all_publications.paused
    elsif params[:scope] == "finished"
      @publications = @all_publications.finished
    else
      @publications = @all_publications.actives
    end
  end

  def favorites
    @favorites = current_user.favorites_publications.actives
  end

  def purchases
  end

  def sales
  end

  def new

    if current_user.get_profile_percent < 100
      redirect_to edit_account_user_path(current_user), alert: "¡Para publicar debes completar tu perfil!"
      return
    end

    check_step

    @publication = current_user.publications.new

    if @step == 1

      unless params[:in_need].nil?
        @in_need = true if params[:in_need] == "true"
        @in_need = false if params[:in_need] != "true"
      end

      if !params[:subject].nil?
        @selected_subject = params[:subject]
        @categories = Category.includes(:subcategories).by_subject(params[:subject]).order(name: :asc)
        unless params[:category_id].nil?
          @selected_category = @categories.find_by_id params[:category_id]
          unless @selected_category.nil?
            @subcategories = @selected_category.subcategories.order(name: :asc)
            unless params[:subcategory_id].nil?
              @selected_subcategory = @subcategories.find_by_id params[:subcategory_id]
            else
              if @selected_category.subcategories.count == 1
                @selected_subcategory = @subcategories.first
              end
            end
          end
        end
      elsif !params[:sample_id].nil?
        sample = Publication.find params[:sample_id]
        @selected_subject = sample.subject
        @categories = Category.includes(:subcategories).by_subject(@selected_subject)
        @selected_category = @categories.find_by_id sample.subcategory.category.id
        @subcategories = @selected_category.subcategories
        @selected_subcategory = @subcategories.find_by_id sample.subcategory.id
      end
    end

  end

  def create

    check_step
    @plans = Plan.all.order(priority: :asc)
    @publication = current_user.publications.new params_permit_create
    params[:publication][:step] = @step

    if @publication.save
      @publication.update_attribute :plan_id, @plans.first.id
      redirect_to edit_account_publication_path(@publication, step: 2)
    else
      redirect_to new_account_publication_path(step: 1), alert: "¡Ha ocurrido un error inesperado!"
    end
  end

  def edit
    @step = params[:step].to_i
    @plans = Plan.all.order(priority: :asc)

    @publication = current_user.publications.find params[:id]

    validate_steps

    @publication.publication_images.where(source: nil).delete_all

    if @publication.publication_images.count == 0
      @publication.publication_images.new
    end

    unless @publication.in_need.nil?
      @in_need = @publication.in_need
    end

    unless params[:in_need].nil?
      @in_need = true if params[:in_need] == "true"
      @in_need = false if params[:in_need] != "true"
    end

    unless params[:errors].nil?
      @errors = JSON.parse params[:errors]
    end

    if @step == 2 && @publication.subject == Publication::ANIMALES && !@publication.age.nil?
      @age_selector = @publication.age.to_s.split(" ")
      if @age_selector.count > 0
        @age_selector = @age_selector[1]
      end
      @publication.age = @publication.age.to_s.gsub(" ", "").gsub("Año(s)", "").gsub("Mes(es)", "")
    end

    if !@publication.status.nil? && @publication.status > 0
      @selected_subject = @publication.subject
      @categories = Category.includes(:subcategories).by_subject(@publication.subject).order(name: :asc)
      @selected_category = @categories.find_by_id @publication.subcategory.category_id
      @subcategories = @selected_category.subcategories.order(name: :asc)
      @selected_subcategory = @subcategories.find_by_id @publication.subcategory_id

      if !params[:subject].nil?
        @selected_subject = params[:subject]
        @categories = Category.includes(:subcategories).by_subject(params[:subject]).order(name: :asc)
        unless params[:category_id].nil?
          @selected_category = @categories.find_by_id params[:category_id]
          unless @selected_category.nil?
            @subcategories = @selected_category.subcategories.order(name: :asc)
            unless params[:subcategory_id].nil?
              @selected_subcategory = @subcategories.find_by_id params[:subcategory_id]
            else
              if @selected_category.subcategories.count == 1
                @selected_subcategory = @subcategories.first
              end
            end
          end
        end
      end

      #@plans = @plans.where("priority > ?", @publication.plan.priority)
    end

    check_step
  end

  def update

    check_step

    @publication = current_user.publications.find params[:id]
    params[:publication][:step] = @step

    #Capitalización de campos de texto para uniformidad
    params[:publication][:title] = params[:publication][:title].titleize unless params[:publication][:title].nil?
    # params[:publication][:description] = params[:publication][:description].capitalize unless params[:publication][:description].nil?
    params[:publication][:warranty_description] = params[:publication][:warranty_description].capitalize unless params[:publication][:warranty_description].nil?

    if @publication.update params_permit_update
      @publication.update_attribute(:age, "#{params[:publication][:age]} #{params_permit_create_none[:age_selector]}") if @step == 2 && @publication.subject == Publication::ANIMALES

      if @step == 2
        if @publication.publication_images.where.not(source: nil).count == 0
          redirect_to edit_account_publication_path(@publication, step: @step), alert: "Debes ingresar al menos 1 imagen."
          return
        end
      end

      @publication.update_attribute(:end_date, Time.now + 1.month) if @step == 3 && @publication.end_date.nil?

      if @step +1 < 4
        redirect_to edit_account_publication_path(@publication, step: @step + 1)
      else
        if @publication.status == 0 || @publication.status.nil?
          Notification.create_and_send(Notification::PUBLICATION_CREATED, @publication, current_user)
        end
        @publication.update_attribute(:status, 1) if @step == 3
        redirect_to edit_account_publication_path(@publication, step: @step + 1), notice: "Tu publicación ya se encuentra al aire. Usa tus puntos para más exposición y tiempo ilimitado para tu publicación."
      end
    else

      @publication.title = params[:publication][:title].titleize unless params[:publication][:title].nil?
      # @publication.description = params[:publication][:description].capitalize unless params[:publication][:description].nil?
      @publication.kind = params[:publication][:kind] unless params[:publication][:kind].nil?
      @publication.units = params[:publication][:units] unless params[:publication][:units].nil?
      @publication.price = params[:publication][:price] unless params[:publication][:price].nil?
      @publication.city_id = params[:publication][:city_id] unless params[:publication][:city_id].nil?
      @publication.address = params[:publication][:address] unless params[:publication][:address].nil?
      @publication.year = params[:publication][:year] unless params[:publication][:year].nil?
      @publication.year = params[:publication][:year] unless params[:publication][:year].nil?
      @publication.brand = params[:publication][:brand] unless params[:publication][:brand].nil?
      @publication.km = params[:publication][:km] unless params[:publication][:km].nil?
      @publication.model = params[:publication][:model] unless params[:publication][:model].nil?
      @publication.transmission = params[:publication][:transmission] unless params[:publication][:transmission].nil?
      @publication.cylinder = params[:publication][:cylinder] unless params[:publication][:cylinder].nil?
      @publication.color = params[:publication][:color] unless params[:publication][:color].nil?
      @publication.fuel_type = params[:publication][:fuel_type] unless params[:publication][:fuel_type].nil?
      @publication.shipping = params[:publication][:shipping] unless params[:publication][:shipping].nil?
      @publication.pickup = params[:publication][:pickup] unless params[:publication][:pickup].nil?
      @publication.shipping_price = params[:publication][:shipping_price] unless params[:publication][:shipping_price].nil?
      if @step == 2 && @publication.subject == Publication::ANIMALES
        @publication.age = "#{params[:publication][:age]} #{params_permit_create_none[:age_selector]}" unless params[:publication][:age].nil?
      end
      @publication.willing_to_move = params[:publication][:willing_to_move] unless params[:publication][:willing_to_move].nil?
      @publication.to_agree = params[:publication][:to_agree] unless params[:publication][:to_agree].nil?
      @publication.with_ac = params[:publication][:with_ac] unless params[:publication][:with_ac].nil?
      @publication.uniq_owner = params[:publication][:uniq_owner] unless params[:publication][:uniq_owner].nil?
      @publication.for_adoption = params[:publication][:for_adoption] unless params[:publication][:for_adoption].nil?
      @publication.for_adoption = params[:publication][:number] unless params[:publication][:number].nil?
      @publication.for_adoption = params[:publication][:total_mtr] unless params[:publication][:total_mtr].nil?
      @publication.for_adoption = params[:publication][:builded_mtr] unless params[:publication][:builded_mtr].nil?
      @publication.for_adoption = params[:publication][:estrato] unless params[:publication][:estrato].nil?
      @publication.for_adoption = params[:publication][:admin_price] unless params[:publication][:admin_price].nil?
      @publication.for_adoption = params[:publication][:warranty] unless params[:publication][:warranty].nil?
      @publication.for_adoption = params[:publication][:warranty_description].titleize unless params[:publication][:warranty_description].nil?

      # unless params[:publication][:publication_images_attributes].nil?
      #   params[:publication][:publication_images_attributes].each do |params_pi|
      #     #@publication.publication_images.create params_pi
      #   end
      # end

      @publication.save validate: false

      redirect_to edit_account_publication_path(@publication, step: @step, errors: @publication.errors.to_json), alert: "Tienes algunos campos con errores."
    end
  end

  def change_status
    publication = current_user.publications.find params[:id]
    publication.update_attribute :status, params[:status]
    redirect_to account_publications_path, notice: "¡Publicación #{publication.title} ha sido pasada al estado #{publication.get_status} correctamente!"
  end

  def change_plan
    publication = current_user.publications.find params[:id]
    plan = Plan.find_by_id params[:plan_id]

    if current_user.current_points >= plan.points
      publication.update_attribute :plan_id, plan.id
      redirect_to account_publications_path, notice: "¡Publicación #{publication.title} es ahora una publicación #{publication.plan.name}!"
    else
      redirect_to account_publications_path, alert: "¡No tienes suficientes puntos, te faltan #{plan.points - current_user.current_points}!"
    end
  end

  private

  def load_data
    @not_show_main_banner = true
  end

  def params_permit_create
    params.require(:publication).permit(:subject, :subcategory_id, :step, :in_need)
  end

  def params_permit_create_none
    params.require(:none).permit(:age_selector)
  end

  def params_permit_update
    params.require(:publication).permit(:in_need, :subject, :subcategory_id, :title, :description, :kind, :units, :price, :step, :start_date, :city_id, :address, :year, :brand, :km, :model, :transmission, :cylinder, :color, :fuel_type, :shipping, :pickup, :shipping_price,
     :age, :to_agree, :with_ac, :warranty, :warranty_description, :video,
    :uniq_owner, :for_adoption, :number, :total_mtr, :builded_mtr, :estrato, :admin_price , publication_images_attributes: [:source, :id, :_destroy])
  end

  def check_step
    @step = params[:step].to_i
    if params[:step].nil?
      @step = 1
    elsif @step > 4
      redirect_to new_account_publication_path(step: 1)
      return
    end
  end

  def validate_steps
    if (@publication.title.nil? || @publication.title == "") && @step > 2
      redirect_to edit_account_publication_path(@publication, step: 2), alert: "Termina primero los campos del paso 2."
      return
    # elsif @step > 3
    #   redirect_to edit_account_publication_path(@publication, step: 3), alert: "Termina primero los campos del paso 3."
    #   return
    end
  end

end

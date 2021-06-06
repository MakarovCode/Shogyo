class Account::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :unsubscribe_emailing], if: lambda { |controller| session[:native_app].nil? }
  acts_as_token_authentication_handler_for User, unless: lambda { |controller| session[:native_app].nil? }

  #autocomplete :city, :name#, :display_value => :full_name

  before_action :load_data

  def autocomplete_city_name
    if user_signed_in?
      unless current_user.country_id.nil?
        @cities = City.includes({department: :country}).where({countries: {id: current_user.country_id}}).by_term(params[:term]).references(:country)
      else
        unless session[:country_id].nil?
          @cities = City.includes({department: :country}).where({countries: {id: session[:country_id]}}).by_term(params[:term]).references(:country)
        else
          @cities = City.by_term(params[:term])
        end
      end
    else
      unless session[:country_id].nil?
        @cities = City.includes({department: :country}).where({countries: {id: session[:country_id]}}).by_term(params[:term]).references(:country)
      else
        @cities = City.by_term(params[:term])
      end
    end
  end

  def dashboard
    @account_percent = 50
    @questions = PublicationQuestion.pending(current_user)
    @publications = current_user.publications.order(created_at: :desc)
    @purchases = current_user.purchases.seller_not_rated
    @sells = Purchase.buyer_not_rated(current_user)
  end

  def show
    @user = User.find params[:id]
    @reputation = @user.get_reputation_data
    @as_buyer = {positives: 0, neutral: 0, negatives: 0, total: 0}
    @as_seller = {positives: 0, neutral: 0, negatives: 0, total: 0}

    @apply_for_certification = @user.purchases.positives.count >= 3

    @purchases_as_buyer = @user.purchases.order(created_at: :desc).seller_rated.page(1).per(20)
    @purchases_as_seller = Purchase.buyer_rated(@user).order(created_at: :desc).page(1).per(20)

    total = @purchases_as_buyer.count > 0 ? @purchases_as_buyer.count : 1

    @as_buyer[:positives] = (@purchases_as_buyer.positives.count*100)/total
    @as_buyer[:neutrals] = (@purchases_as_buyer.neutrals.count*100)/total
    @as_buyer[:negatives] = (@purchases_as_buyer.negatives.count*100)/total
    @as_buyer[:total] = @purchases_as_buyer.count

    @as_seller[:positives] = (@purchases_as_seller.positives.count*100)/total
    @as_seller[:neutrals] = (@purchases_as_seller.neutrals.count*100)/total
    @as_seller[:negatives] = (@purchases_as_seller.negatives.count*100)/total
    @as_seller[:total] = @purchases_as_seller.count

    @show_reputation_as_buyer = @purchases_as_buyer.count >= 3
    @show_reputation_as_seller = @purchases_as_seller.count >= 3

    @publications = @user.publications.actives.order(created_at: :desc).page(params[:page]).per(15)
  end

  def edit
    @user = User.find params[:id]

    if current_user == @user
      if @user.name.nil?
        uAuth = @user.user_authentications.last
        unless uAuth.nil?
          unless uAuth.params.nil?
            unless uAuth.params.info.nil?
              @user.name = uAuth.params.info.name
              @user.remote_image_url = "#{uAuth.params.info.image.gsub('http://','https://')}?width=500"
              @user.save
            end
          end
        end
      end

    else
      redirect_to account_user_path @user.id
    end
  end

  def update
    @user = User.find params[:id]
    if current_user == @user
      unless params[:user][:interest_ids].nil?
        @user.update_attribute :interest_ids, params[:user][:interest_ids]
        redirect_to params[:redirect_to], notice: "¡Tus intereses han sido actualizados!"
        return
      end
      if @user.update params_permit
        if @user.get_profile_percent == 100 && !@user.achivement_acomplished_by_id(7)
          Notification.create_with_achivement(7, @user, @user)
        end
        redirect_to account_user_path(@user), notice: "¡Información actualizada correctamente!"
      else
        render :edit
      end
    else
      redirect_to account_user_path @user.id
    end
  end

  def unsubscribe_emailing
    @user = User.find_by_email params[:email]
    @user.update_attribute :receive_email_ads, false

    redirect_to root_path, notice: "¡Ya no recibiras más correos de novedades de AgroNeto, los correos de notificaciones de ventas, compras o consultas no se verán afectados, éstos los puedes deshabilitar desde tu cuenta principal!"
  end


  private

  def load_data
    @not_show_main_banner = true
  end

  def params_permit
    params.require(:user).permit(:email, :password, :password_confirmation, :profession, :name, :main_activity, :phone, :address, :birthdate, :city_id, :image, :interest_ids)
  end

end

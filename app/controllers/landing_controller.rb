class LandingController < ApplicationController

  before_action :load_data

  def index
    @all_posts = Post.actives

    @posts = @all_posts.where(country_id: @country_id)

    @all_publications = Publication.all
    @publications = @all_publications.ready.order(created_at: :desc).page(params[:page]).per(15)

    @features = @all_publications.ready.order(visits_count: :desc).first(16)
    if user_signed_in?
      @last_publications = current_user.visited_publications.ready.order(created_at: :desc).first(16)
    else
      @last_publications = @all_publications.ready.order(created_at: :desc).first(16)
    end

    @questions = ConsultQuestion.recents.first(5)

    @all_users = User.all
    @users = @all_users.profile_complete.order(created_at: :desc).page(params[:page]).per(15)

  end

  def select_country
    @not_show_main_banner = true
    @subtitle = "Seleccion de país"
    @countries = Country.all.order(name: :asc)
  end

  def selected_country
    country = Country.find params[:country_id]
    if user_signed_in?
      current_user.update_attribute :country_id, country.id
    else
      session[:country_id] = country.id
    end
    redirect_to params[:redirect_to], success: "Bienvenido a AgroNeto - #{country.name}"
  end

  def accept_cookies
    session[:cookies] = true
    render status: 200, json: {message: "Cookies aceptadas"}
  end

  private

  def load_data
    @subtitle = "El Mercado"
  end

end

class Market::PublicationsController < ApplicationController

  autocomplete :subcategory, :name

  before_action :authenticate_user!, except: [:index, :show]

  before_action :load_data

  def index

    if params[:search_term].nil? || params[:search_term] == ""
      @not_show_main_banner = false
      @last_publications = []
      if user_signed_in?
        @last_publications = current_user.visited_publications.ready.order(created_at: :desc)
      end
      @features = Publication.ready.order(visits_count: :desc).first(16)
      @new_publications = Publication.ready.order(created_at: :desc).page(params[:page]).per(21)
    else
      # Publication.reindex

      order = {_score: :desc}

      if params[:order] == 2
        order = {price: :asc}
      elsif params[:order] == 3
        order = {price: :desc}
      end

      aggs = {kind: {min_doc_count: 1}, subject: {min_doc_count: 1}, subcategory_name: {min_doc_count: 1}, category_name: {min_doc_count: 1}, city_name: {min_doc_count: 1}}

      if !params[:min].nil? && !params[:max].nil?
        price_ranges = [{to: params[:min].to_i}, {from: params[:min].to_i, to: params[:max].to_i}, {from: params[:max].to_i}]
        aggs[:price] =  {ranges: price_ranges}
      elsif !params[:min].nil? && params[:max].nil?
        price_ranges = [{to: 100000000}, {from: params[:min].to_i, to: 100000000}, {from: params[:min].to_i}]
        aggs[:price] =  {ranges: price_ranges}
      elsif params[:min].nil? && !params[:max].nil?
        price_ranges = [{to: params[:max].to_i}, {from: 0, to: params[:max].to_i}, {from: 0}]
        aggs[:price] =  {ranges: price_ranges}
      end

      if params[:city]
        aggs[:city][:where] =  {city_name: params[:city]}
      end

      @publications = Publication.ready.search params[:search_term],
      operator: "or",
      fields: [:subcategory_name, :category_name, :title],
      aggs: aggs,
      smart_aggs: false,
      where: {status: 1},
      misspellings: {below: 5},
      track: user_signed_in? ? {user_id: current_user.id} : false,
      suggest: true,
      boost_by: {visits_count: {factor: 50}},
      boost_where: {plan_id: [{value: 1, factor: 10}, {value: 2, factor: 100}]},
      order: order,
      page: params[:page], per_page: 24

      @subcategories = Subcategory.all
      @cities = City.all
    end
  end

  def show
    @publication = Publication.find params[:id]
    @interesting = Publication.last 10
    @user = @publication.user
    if user_signed_in?
      @is_favorite = !current_user.favorites.find_by_publication_id(@publication.id).nil?
      current_user.user_visits.create publication_id: @publication.id
    else
      @is_favorite = false
    end
    @reputation = @publication.user.get_reputation_data
    @publication.update_attribute :visits_count, @publication.visits_count + 1

    @publications = @user.publications.actives.order(created_at: :desc).page(params[:page]).per(15)
  end

  def mark_as_favorite
    publication = Publication.find params[:id]
    if publication.user == current_user
      if params[:redirect_to]
        redirect_to params[:redirect_to], notice: "Opps, no puedes poner favorito una publicación tuya."
      else
        redirect_to market_publication_path(publication), notice: "Opps, no puedes poner favorito una publicación tuya."
      end
      return
    end
    favorite = current_user.favorites.find_by_publication_id(publication.id)
    if favorite.nil?
      favorite = current_user.favorites.create publication_id: publication.id
      redirect_to market_publication_path(publication), notice: "Publicación adicionada a favoritos."
    else
      favorite.delete
      if params[:redirect_to]
        redirect_to params[:redirect_to], notice: "Publicación sacada de favoritos."
      else
        redirect_to market_publication_path(publication), notice: "Publicación sacada de favoritos."
      end
    end
  end

  def ask
    publication = Publication.find params[:id]
    if publication.user == current_user
      redirect_to market_publication_path(publication), alert: "Opps, no puedes preguntar en una publicación tuya."
      return
    end
    question = publication.publication_questions.new question: params[:question]
    question.user_id = current_user.id
    if question.save
      Notification.create_and_send(Notification::NEW_QUESTION, question, publication.user)
      redirect_to market_publication_path(publication), notice: "Pregunta enviada al vendedor, te avisaremos cuando te responda."
    else
      redirect_to market_publication_path(publication), alert: "La pregunta no puede estar vacía"
    end
  end

  def buy

  end

  def forum

  end

  private

  def load_data
    @subtitle = "El Mercado"
    @not_show_main_banner = false
  end

end

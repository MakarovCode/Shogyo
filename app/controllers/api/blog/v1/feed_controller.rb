class Api::Blog::V1::FeedController < Api::ApiNsController

  acts_as_token_authentication_handler_for User, only: [:new, :create, :upload_images]

  layout "layouts/application_api"

  def index

    if request.format.html?
      return
    end

    tmp_feed = []
    posts = []
    questions = []
    publications = []
    push_questions = []
    push_publications = []
    @feed = []

    if params[:search_term].blank?
      if params[:scope].blank? || params[:scope] == "all" || params[:scope] == "posts"
        posts = Post.all.order(date: :desc)
      end

      if params[:scope].blank? || params[:scope] == "all" || params[:scope] == "consults"
        questions = ConsultQuestion.recents
      end

      if params[:scope].blank? || params[:scope] == "all" || params[:scope] == "market"
        publications = Publication.ready.order(created_at: :desc)
      end
      tmp_feed = ((posts + questions + publications).sort_by { |feed| feed.created_at }).reverse!

      if !params[:page].nil? && !params[:per].nil?
        init = (params[:page].to_i - 1) * params[:per].to_i
        eend = init + params[:per].to_i
        tmp_feed = tmp_feed.slice(init, eend) || []
      end
    else

      order = {_score: :desc}

      aggs = {kind: {min_doc_count: 1}, subject: {min_doc_count: 1}, subcategory_name: {min_doc_count: 1}, category_name: {min_doc_count: 1}, city_name: {min_doc_count: 1}}

      tmp_feed = Searchkick.search params[:search_term],
      index_name: [Publication, Post, ConsultQuestion],
      operator: "or",
      fields: [:subcategory_name, :category_name, :title, :content, :content2, :text, :abstract],
      aggs: aggs,
      smart_aggs: false,
      where: {status: 1},
      misspellings: {below: 5},
      # track: user_signed_in? ? {user_id: current_user.id} : false,
      # suggest: true,
      boost_by: {visits_count: {factor: 50}},
      boost_where: {plan_id: [{value: 1, factor: 10}, {value: 2, factor: 100}]},
      # order: order,
      page: params[:page], per_page: params[:per]

      # posts = Post.actives.search params[:search_term],
      # operator: "or",
      # fields: [:subcategory_name, :category_name, :title, :abstract, :content, :content2],
      # aggs: aggs_posts,
      # smart_aggs: false,
      # where: {status: 1},
      # misspellings: {below: 5},
      # track: user_signed_in? ? {user_id: current_user.id} : false,
      # suggest: true,
      # boost_by: {visits_count: {factor: 50}}
      # order: order,
      # page: params[:page], per_page: params[:per]

      # questions = ConsultQuestion.search params[:search_term]
      # boost_by: {visits_count: {factor: 50}}
      # order: order,
      # page: params[:page], per_page: params[:per]
    end

    ads = Ad.where(ad_type: "01").order(created_at: :desc).first(3)



    cont_questions = 0
    cont_publications = 0

    ad_i = 0
    tmp_feed.each_with_index do |feed, i|
      if (i == 0 || i % 8 == 0) && ad_i < ads.count
        @feed.push ads[ad_i]
        ad_i += 1
        @feed.push feed
      else
        @feed.push feed
      end

      if feed.model_name.name == "ConsultQuestion"
        cont_questions += 1
      elsif feed.model_name.name == "Publication"
        cont_publications += 1
      end
    end

    if params[:search_term].blank?
      if cont_questions == 0 && (params[:scope].blank? || params[:scope] == "all" || params[:scope] == "consults")
        push_questions = questions.page(params[:page]).per(3)
      end

      if cont_publications == 0 && (params[:scope].blank? || params[:scope] == "all" || params[:scope] == "market")
        push_publications = publications.page(params[:page]).per(3)
      end
    end

    if params[:scope] == "all"
      poss = [rand(1...2), rand(3...7), rand(9...11), rand(12...15), rand(17...19), rand(20...22), rand(23...24)]

      if @feed.count > 5
        (0..5).each do |i|
          if i % 2 == 1
            @feed[poss[i]] = push_questions[i%3]
          else
            @feed[poss[i]] = push_publications[i%3]
          end
        end
      end
    end

    puts "====>#{@feed}"
    puts "====>#{@feed.count}"

  end

  def new
    @categories = Category.all.order(name: :asc)
  end

  def create
    params.permit!
    if params[:type].to_i != 1
      publication = current_user.publications.new params[:publication]
      publication.status = 1
      publication.plan_id = 1
      publication.start_date = Date.today - 1.day
      publication.end_date = Date.today + 1.year
      if publication.save
        render status: 200, json: {message: "Publicación creada correctamente", id: publication.id}
      else
        render status: 411, json: {message: "Tienes uno o mas errores", errors: publication.errors.full_messages.to_sentence}
      end
    else
      question = current_user.consult_questions.new params[:question]
      if question.save
        render status: 200, json: {message: "Consulta creada correctamente", id: question.id}
      else
        render status: 411, json: {message: "Tienes uno o mas errores", errors: question.errors.full_messages.to_sentence}
      end
    end
  end

  def update
    params.permit!
    if params[:type].to_i != 1
      publication = current_user.publications.find params[:id]
      if publication.update params[:publication]
        render status: 200, json: {message: "Publicación creada correctamente", id: publication.id}
      else
        render status: 411, json: {message: "Tienes uno o mas errores", errors: publication.errors.full_messages.to_sentence}
      end
    else
      question = current_user.consult_questions.new params[:question]
      if question.update params[:publication]
        render status: 200, json: {message: "Consulta creada correctamente", id: question.id}
      else
        render status: 411, json: {message: "Tienes uno o mas errores", errors: question.errors.full_messages.to_sentence}
      end
    end
  end

  def upload_images
    if params[:type].to_i == 1
      question = current_user.consult_questions.find params[:id]
      image = question.consult_question_images.create source: params[:file]
      question.save
      render status: 200, json: {message: "Imagen cargada", url: image.source.url}
    else
      publication = current_user.publications.find params[:id]
      image = publication.publication_images.create source: params[:file]
      publication.save
      render status: 200, json: {message: "Imagen cargada", url: image.source.url}
    end
  end

end

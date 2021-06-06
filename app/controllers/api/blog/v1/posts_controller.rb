class Api::Blog::V1::PostsController < Api::ApiNsController

  layout "layouts/application_api"

  def index
    if params[:category_id].nil?
      if params[:scope] == "recents"
        @posts = Post.all.order(date: :desc)
      else
        @posts = Post.all.order(views_count: :desc)
      end
    else
      if params[:scope] == "recents"
        @posts = Post.includes(:subcategories).where({subcategories: {category_id: params[:category_id]}}).order(views_count: :desc).references(:subcategories)
      else
        @posts = Post.includes(:subcategories).where({subcategories: {category_id: params[:category_id]}}).order(date: :desc).references(:subcategories)
      end
    end

    if !params[:page].nil? && !params[:per].nil?
      @posts = @posts.page(params[:page]).per(params[:per])
    end
  end

  def show
    @post = Post.find params[:id]
  end

  def hot
    @posts = Post.last(3)
    render "index"
  end

end

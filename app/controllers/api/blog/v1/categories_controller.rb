class Api::Blog::V1::CategoriesController < Api::ApiController

  def index
    params.permit!

    @categories = Category.for_news.order(name: :asc)

  end

end

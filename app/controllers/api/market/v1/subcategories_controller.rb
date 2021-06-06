class Api::Market::V1::SubcategoriesController < Api::ApiNsController

  def index
    @aux = Subcategory.includes(:category).actives.where({categories: {for_news: [false, nil]}}).search(params[:term]).references(:category)
    @subcategories = []
    @aux.each do |sub|
      tmp = @subcategories.find {|s| s.name.downcase == sub.name.downcase }
      if tmp.nil?
        @subcategories.push sub
      end
    end
  end

end

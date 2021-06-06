class Api::Market::V1::CommoditiesController < Api::ApiNsController
  def index
    @full_data = false
    @commodities = Commodity.all.order(priority: :asc)
  end

  def show
    @full_data = true
    @commodities = Commodity.find params[:id]

    if params[:scope] == "anual"
      @variations = @commodities.variations.where(created_at: Date.today.at_beginning_of_year..Date.today)
    else
      @variations = @commodities.variations.where(created_at: (Date.today - 1.month)..Date.today)
    end

    render "index"
  end
end

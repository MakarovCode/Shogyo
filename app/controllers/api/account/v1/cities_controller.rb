class Api::Account::V1::CitiesController < Api::ApiController

  def index
    params.permit!

    unless current_user.country_id.nil?
      @cities = City.includes(:department).where({departments: {country_id: current_user.country_id}}).references(:department)
    else
      @cities = City.all.order(name: :asc)
    end

  end

end

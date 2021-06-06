class Api::Consults::V1::WeatherController < Api::ApiNsController

  # acts_as_token_authentication_handler_for User, only: [:create, :update, :voted, :visited]
  layout "layouts/application_api"

  def index
    @country = Country.find_by_id params[:country_id]
  end

  def historic
  end

  def actual
  end

  def forecast
  end

  def maps
  end

end

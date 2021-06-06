class Consults::WeatherController < ApplicationController

  before_action :load_data

  def index
    @country = Country.find_by_id @country_id
  end

  def load_data
    @subtitle = "Clima"
  end

end

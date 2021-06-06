class Api::Account::V1::CountriesController < Api::ApiNsController
  def index
    @countries = Country.all.order(name: :asc)
  end
end

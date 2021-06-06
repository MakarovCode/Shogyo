class Api::Account::V1::InterestsController < Api::ApiController
  def index
    @interests = Interest.all.order(name: :asc)
  end
end

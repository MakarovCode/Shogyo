class Api::Market::V1::PublicationsController < Api::ApiNsController

  layout "layouts/application_api"

  def show
    @publication = Publication.ready.find params[:id]
    @user = @publication.user
    @reputation = @publication.user.get_reputation_data
    @publication.update_attribute :visits_count, @publication.visits_count + 1
  end

end

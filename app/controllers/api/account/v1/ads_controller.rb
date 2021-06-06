
class Api::Account::V1::AdsController < Api::ApiController

  respond_to :json

  def index
    @ad = Ad.actives.where(ad_type: params[:type]).first
  end

  def read
    ad = Ad.find params[:id]
    ahoy.track "Mobile Viewed ad", title: "#{ad.title}", ad_id: ad.id

    render status: 200, json: {message: "OK"}
  end

  def engaged
    ad = Ad.find params[:id]

    ahoy.track "Mobile Viewed ad", title: "#{ad.title}", ad_id: ad.id

    if params[:platform] == "ios"
      unless ad.link.nil?
        redirect_to ad.link
      else
        redirect_to root_path
      end
    else
      unless ad.link.nil?
        redirect_to ad.link
      else
        redirect_to root_path
      end
    end
  end

end

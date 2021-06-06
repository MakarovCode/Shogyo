class AdsController < ApplicationController

  def show
    create_visit
  end

  def update
    create_visit
  end

  private

  def create_visit
    ad = Ad.find params[:id]
    ad.update_attribute :clicks_count, ad.clicks_count + 1
    ahoy.track "Clicked ad", title: "#{ad.title}", ad_id: ad.id
    if ad.link == "" || ad.link == nil
      redirect_to root_path
    else
      redirect_to ad.link
    end
  end

end

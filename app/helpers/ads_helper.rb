module AdsHelper
  def self.load_ad(type)
    if type == "01"
      ads = Ad.where(ad_type: type).order(created_at: :desc).first(2)
      ads.each do |ad|
        ad.update_attribute :views_count, ad.views_count + 1
      end
      ads
    else
      ad = Ad.where(ad_type: type).last
      unless ad.nil?
        ad.update_attribute :views_count, ad.views_count + 1
        ad
      end
    end
  end
end

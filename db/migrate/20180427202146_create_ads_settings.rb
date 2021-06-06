class CreateAdsSettings < ActiveRecord::Migration::Current
  def change
    create_table :ads_settings do |t|
      t.boolean :use_adsense

      t.timestamps
    end
  end
end

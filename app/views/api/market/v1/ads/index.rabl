object @ads

attributes :id

node :image do |ad|
  ad.image.mobile_banner.url
end

node :link do |ad|
  unless ad.link.empty?
    ad.link
  else
    "none"
  end
end

object @countries

attribtues :id, :name

node :flag do |country|
  if flag.square.url.nil?
    flag.square.url
  else
    asset_path "no-image.png"
  end
end

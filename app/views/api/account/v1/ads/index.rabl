object @ad

attributes :id, :kind

node :message do |ad|
	"Ad"
end

node :link do |ad|
	unless ad.link.nil?
		ad.link
	else
		"none"
	end
end

node :title do |ad|
	unless ad.title.nil?
		locale_of ad.title
	else
		"Sin titulo"
	end
end


node :image do |ad|
	unless ad.image.url.nil?
		ad.image.cover.url
	else
		asset_utl "no-image.png"
	end
end

object @feed

node :type do |feed|
  unless feed.blank?
    feed.model_name.name
  end
end

node :ad do |feed|
  unless feed.blank?
    if feed.model_name.name == "Ad"
      partial("api/market/v1/ads/index", object: feed)
    else
      nil
    end
  end
end

node :post do |feed|
  unless feed.blank?
    if feed.model_name.name == "Post"
      partial("api/blog/v1/posts/index", object: feed)
    else
      nil
    end
  end
end

node :question do |feed|
  unless feed.blank?
    if feed.model_name.name == "ConsultQuestion"
      partial("api/consults/v1/questions/index", object: feed)
    else
      nil
    end
  end
end

node :publication do |feed|
  unless feed.blank?
    if feed.model_name.name == "Publication"
      partial("api/market/v1/publications/index", object: feed)
    else
      nil
    end
  end
end

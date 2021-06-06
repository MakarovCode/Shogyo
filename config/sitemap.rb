host "agroneto.com"

sitemap :landing do
  url landing_index_url, last_mod: Time.now, change_freq: "daily", priority: 1.0
end

sitemap :market do
  url market_publications_url, last_mod: Time.now, change_freq: "daily", priority: 1.0
end

sitemap :blog do
  url blog_posts_url, last_mod: Time.now, change_freq: "daily", priority: 1.0
end

sitemap :consults do
  url consults_questions_path(scope: "hot"), last_mod: Time.now, change_freq: "daily", priority: 1.0
end

sitemap_for Post.actives, name: :news do |post|
  url blog_post_url(post), last_mod: post.updated_at, priority: 1.0
end

sitemap_for Publication.ready, name: :publications do |publication|
  url market_publication_url(publication), last_mod: publication.updated_at, priority: 1.0
end

sitemap_for ConsultQuestion.all, name: :questions do |question|
  url consults_question_path(question), last_mod: question.updated_at, priority: 1.0
end

# sitemap :animes do
#   url animes_url, last_mod: Time.now, change_freq: "daily", priority: 1.0
# end
#
# sitemap :games do
#   url games_url, last_mod: Time.now, change_freq: "daily", priority: 1.0
# end

# sitemap :forum do
#   url "#{root_url}forum", last_mod: Time.now, change_freq: "daily", priority: 1.0
# end
#
# sitemap_for Anime.all, priority: 0.8
# #sitemap_for animes_url, priority: 0.8
#
# sitemap_for Thredded::Messageboard.all, name: :forums do |foro|
#   url "#{root_url}forum/#{foro.slug}", last_mod: foro.updated_at, priority: 1.0
# end
#
# sitemap_for Thredded::Topic.all, name: :forum_topics do |topic|
#   time = topic.updated_at
#   if topic.posts.count > 0
#     time = topic.posts.last.updated_at
#   end
#   unless topic.messageboard.nil?
#     url "#{root_url}forum/#{topic.messageboard.slug}/#{topic.slug}", last_mod: time, priority: 1.0
#   end
# end


# Ping search engines after sitemap generation:
#

ping_with "https://#{host}/sitemap.xml"

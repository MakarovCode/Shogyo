
set :output, "log/whenever.log"

env :PATH, ENV['PATH']

every 1.day, at: "9pm" do
  rake "sitemap:generate"
end

every 1.day, at: "2pm" do
  runner "User.finish_profile_notification"
end

every 1.day, at: "11pm" do
  runner "Publication.start_publications_notification"
end

every 1.day, at: "10am" do
  runner "Publication.end_publications_notification"
end

every 1.day, at: "18pm" do
  runner "Purchase.reminders_notifications"
end

every 1.day, at: "3pm" do
  runner "User.periodic_updates('week')"
end

every 1.day, at: "8am" do
  runner "User.terms_update('')"
end

#Colombia y Otros
every 1.day, at: "5pm" do
  runner "User.daily_push(1)"
end

#España
every 1.day, at: "11am" do
  runner "User.daily_push(2)"
end

#Mexico
every 1.day, at: "5pm" do
  runner "User.daily_push(3)"
end

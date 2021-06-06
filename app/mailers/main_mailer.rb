class MainMailer < ApplicationMailer

  def sendit(user, subject, text, link, action)
    @info = Information.first
    @action = action
    @text = text
    @link = link
    @user = user

    #mail to: user.email, subject: subject
  end

end

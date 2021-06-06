class Account::FeedbacksController < ApplicationController

  before_action :authenticate_user!, if: lambda { |controller| session[:native_app].nil? }
  acts_as_token_authentication_handler_for User, unless: lambda { |controller| session[:native_app].nil? }
  
  before_action :load_data


  def index
    @feedbacks = current_user.feedbacks.where("publication_id IS NOT NULL")
  end

  def load_data
    @not_show_main_banner = true
  end

end

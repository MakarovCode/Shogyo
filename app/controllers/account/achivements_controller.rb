class Account::AchivementsController < ApplicationController

  before_action :authenticate_user!, if: lambda { |controller| session[:native_app].nil? }
  acts_as_token_authentication_handler_for User, unless: lambda { |controller| session[:native_app].nil? }

  def index
    @not_show_main_banner = true
    @user = current_user
    @achivements = Achivement.all.order(points: :asc)
  end

end

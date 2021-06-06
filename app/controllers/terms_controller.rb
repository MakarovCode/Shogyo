class TermsController < ApplicationController

  before_action :load_data

  def index

  end

  private

  def load_data
    @not_show_main_banner = true
    @subtitle = "Términos y condiciones"
  end

end

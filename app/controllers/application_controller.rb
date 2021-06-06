class ApplicationController < ActionController::Base

	protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
	protect_from_forgery with: :exception, unless: Proc.new { |c| c.request.format == 'application/json' }

	before_action :track_action, unless: Proc.new { |c| c.request.format == 'application/json' }
	before_action :load_info, unless: Proc.new { |c| c.request.format == 'application/json' }
	before_action :configure_permitted_parameters, if: :devise_controller?
#	before_action :check_country, unless: Proc.new { |c| c.request.format == 'application/json' }

	rescue_from ActionController::RoutingError, with: :not_found
	# rescue_from ActionController::UnknownController, with: :not_found
	rescue_from ActiveRecord::RecordNotFound, with: :not_found
	#	rescue_from Exception, with: :exception

	layout "layouts/application"

	protected

	def check_country
		if params[:native_app].nil?
			@country_id = session[:country_id]
			unless params[:controller].include? "admin"
				if !user_signed_in? && params[:controller] != "devise/sessions" && params[:controller] != "devise/registrations" && params[:controller] != "devise/passwords" && params[:controller] != "devise/confirmations" && !request.path.include?("blog/posts") && !request.path.include?("landing/select_country") && !request.path.include?("landing/selected_country") && !request.path.include?("consults") && !request.path.include?("accept_cookies") && !request.path.include?("unsubscribe_emailing")
					if user_signed_in?
						if current_user.country_id.nil?
							redirect_to main_app.select_country_landing_index_path(redirect_to: request.path)
						else
							@country_id = current_user.country_id
						end
					else
						if session[:country_id].nil?
							redirect_to main_app.select_country_landing_index_path(redirect_to: request.path)
						end
					end
				end
			end
		end
	end

	def load_info
		# if !params[:native_app].nil? || !session[:native_app].nil?
		# 	session[:native_app] = true
		# end
		# PublicationImage.ri(params[:num_ri].to_i)
		unless params[:controller].nil?
			unless params[:controller].include? "admin"
				@info = Information.first
				@ads_settings = AdsSetting.first
				if @ads_settings.nil?
					@ads_settings = AdsSetting.create use_adsense: false
				end
				if user_signed_in?
					@notifications = current_user.notifications.unread.order(created_at: :desc)
					@tfavorites = current_user.favorites.order(created_at: :desc)
				end
			end
		end
	end

	def track_action
		
	end

	def not_found
		respond_to do |format|
			format.html { render :file => File.join(Rails.root, 'public', '404.html') }
			format.json { render status: 404, json:  {message: "Recurso no encontrado, revisa tu petición"} }
		end
	end

	def exception
		respond_to do |format|
			format.html { render :file => File.join(Rails.root, 'public', '500.html') }
			format.json { render status: 500, json:  {message: "Ha ocurrido un error inesperado, revisa tu petición"} }
		end
	end

	def after_sign_in_path_for(resource)
		if resource.class.name.to_s == "User"
			# ULTIMA URL ANTES DE INICIAR SESION
			if current_user.sign_in_count <= 1
				edit_account_user_path(current_user)
			else
				root_path
			end
		else
			admin_dashboard_path(resource)
		end
	end

	def after_sign_out_path_for(resource)
		root_path
	end

	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :country_id])
	end
end

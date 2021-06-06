Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  default_url_options :host => "http://localhost:3000" if Rails.env == "development"
  default_url_options :host => "http://agroneto.com" if Rails.env == "production"

  devise_for :users, controllers: { registrations: 'users/registrations' }
  devise_for :admin_users, ActiveAdmin::Devise.config

  # mount Thredded::Engine => '/forum'

  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "landing#index"

  resources :landing, only: [:index] do
    collection do
      get "select_country"
      post "accept_cookies"
      post "selected_country"
    end
  end
  resources :terms, only: [:index]
  resources :ads, as: "awesome", path: "awesome", only: [:show, :update]

  namespace :blog do
    resources :posts, only: [:index, :show]
  end

  namespace :consults do
    resources :questions, only: [:index, :show, :create, :update] do
      member do
        post "voted"
      end
      resources :answers, only: [:create, :update] do
        member do
          post "voted"
        end
      end
    end

    resources :weather, only: [:index]
  end

  namespace :market do
    resources :publications, only: [:index, :show] do
      collection do
        get "forum"
        get "autocomplete_subcategory_name"
        get "simple_new"
        post "simple_create"
      end
      member do
        post "ask"
        post "mark_as_favorite"
      end
      resources :purchases, only: [:create]
    end

    resources :feedbacks, only: [:new, :create]
  end

  namespace :account do
    resources :users, only: [:show, :edit, :update] do
      collection do
        get "dashboard"
        get "autocomplete_city_name"
        get "unsubscribe_emailing"
      end

      resources :contacts, only: [:index, :show, :create] do
        member do
          post "close"
        end
      end

      resources :notifications, only: [:show]
    end

    resources :feedbacks, only: [:index]
    resources :purchases, only: [:index, :show] do
      member do
        post "mark_as_charged"
        post "mark_as_sent"
        post "mark_as_payed"
      end
    end
    resources :reputations, only: [:index, :new, :update]

    resources :publications, only: [:index, :new, :create, :edit, :update] do
      collection do
        get "favorites" #COMO COMPRADOR
        get "purchases" #COMO COMPRADOR
        get "sales" #COMO VENDEDOR
      end
      member do
        post "make_gold"
        post "change_status"
        post "change_plan"
      end
    end

    resources :questions, only: [:index, :update]

    resources :achivements, only: [:index]
  end

  namespace :api do

    namespace :market do
      namespace :v1 do

        resources :subcategories, only: [:index]

        resources :commodities, only: [:index, :show]
        resources :publications, only: [:new, :create, :show]
      end
    end

    namespace :blog do
      namespace :v1 do
        resources :feed, only: [:index, :new, :create] do
          collection do
            post "upload_images"
          end
        end
        resources :categories, only: [:index]
        resources :posts, only: [:index, :show] do
          collection do
            get "hot"
          end
        end
      end
    end

    namespace :consults do
      namespace :v1 do
        resources :questions, only: [:index, :show, :create, :update] do
          member do
            post "voted"
            post "visited"
          end
          resources :answers, only: [:index, :create, :update] do
            member do
              post "voted"
            end
          end
        end
        resources :weather, only: [:index] do
          collection do
            post "historic"
            post "actual"
            post "forecast"
            post "maps"
          end
        end
      end
    end

    namespace :account do
      namespace :v1 do

        resources :cities, only: [:index]
        resources :feedbacks, only: [:create]
        resources :contacts, only: [:index, :show, :create]
        resources :countries, except: [:index]
        resources :interests, only: [:index]

        resources :sessions, except: [:index, :show, :create, :update, :new, :edit, :destroy] do
          collection do
            post "login"
            post "facebook_login"
            post "register"
          end
        end

        resources :ads, only: [:index] do
          member do
            post "read"
            get "engaged"
          end
        end

        resources :feedbacks, only: [:create]

        resources :notifications, only: [:index] do
          collection do
            get "unread_by_user"
            post "read_all"
          end
          member do
            post "arrived"
            post "read"
          end
        end

        resources :users, except: [:index, :new, :create, :edit, :destroy] do

          collection do
            get "terms"
          end

          member do
            post "confirm_email"
            post "upload_image"
            post "confirm_email"
          end
        end

      end
    end
  end

end

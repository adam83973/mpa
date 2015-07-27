MathPlus::Application.routes.draw do

  resources :messages


  resources :badge_requests


  root to: 'static_pages#home'
  post 'static_pages/mission_lookup', to: 'static_pages#mission_lookup'
  get 'badge_home', to: 'static_pages#badges'

  resources :badges

  resources :avatars

  namespace :operations_pages do
      get :main
      get :trial_applet
      get :creating_an_opportunity
  end

  get  'opportunities/by_status', to: 'opportunities#by_status'
  post 'opportunities/update_status', to: 'opportunities#update_status'

  match '/emails',     to: 'emails#new',             via: 'get'
  resources "emails", only: [:new, :create]

  resources :opportunities do
    resources :notes
    collection do
      get :add_parent
      get :add_student
      get :trial_date
      get :attended_trial
      get :missed_trial
      get :add_to_class
      get :update_interest
      post :add_trial
      get :add_trial
    end
  end

  resources :registrations do
    collection do
      post :switch
      get :hold
      get :drop
      get :cancel_hold
      get :cancel_drop
      get :attended_first_class
    end
  end

  resources :enrollment_change_requests do
    collection { get :email }
  end


  resources :reports
  resources :issues
  resources :occupations

  resources :occupation_levels do
    collection { post :import }
  end

  resources :daily_location_reports
  resources :notes
  resources :stages
  resources :videos
  resources :class_sessions, only: [:new, :create, :destroy]
  resources :standards
  resources :experience_points
  resources :experiences
  resources :grades
  resources :courses
  resources :resources
  resources :strategies
  resources :devise

  devise_for :users, :skip => [:registrations]
    as :user do
      get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
      put 'users' => 'devise/registrations#update', :as => 'user_registration'
      put 'users' => 'devise/registrations#update', :as => 'user_registration'
    end


  get 'reports/', to: 'reports#new'
  post 'reports/display', to: 'reports#show'
  post 'experience_points/points_lookup', to: 'experience_points#points_lookup'
  post 'students/update_credits', to: 'students#update_credits'
  post 'notes/completed', to: 'notes#completed'
  post 'users/deactivate/:id', to: 'users#deactivate'
  get 'students/attended_first_class', to: 'students#attended_first_class'
  get 'mission_lookup', to: 'static_pages#mission_lookup'
  get 'code', to: 'static_pages#enter_code'

  resources :leads do
    resources :notes
  end

  resources :students do
    collection do
      post :import
      post :create_from_opportunity
    end
    resources :notes
  end

  resources :experiences do
    collection { post :import }
  end

  resources :users do
    collection do
      post  :create_from_opportunity
      post  :import
      get   :my_account
      get   :password_reset
      get   :send_hold_form
      get   :send_termination_form
      post  :infusion_request
      get   :missed_appointment
      post  :appointment_reschedule_request
      get   :year_end_promotion
      get   :promotion
      post  :appointment_request
    end
    resources :notes
  end

  resources :locations do
    collection do
      post :import
      get :list
    end
  end

  resources :courses do
    collection { post :import }
  end

  resources :offerings_students do
    collection { post :import }
  end

  resources :offerings_users do
    collection { post :import }
  end

  resources :offerings do
    collection do
      post :import
      get :offerings_by_location
    end
  end

  resources :resources do
    collection { post :import }
  end

  resources :offerings_students do
    collection { post :import }
  end

  resources :standards do
    collection { post :import }
  end

  resources :lessons do
    collection { post :import }
  end

  resources :courses do
    collection { post :import }
  end

  resources :problems do
    collection { post :import }
  end

  resources :activities do
    collection { post :import }
  end

  post "class_sessions/start_class"
  get "class_sessions/end_class"
  get "class_sessions/remove_student"
  get "binders/briefcase"
  get "binders/middleschool"
  get "schedules/powell"
  get "schedules/new_albany"

  get "infusion_pages/home"
  get "infusion_pages/add_contact"
  get "infusion_pages/add_existing_id"
  get "infusion_pages/possible_contacts"
  get "infusion_pages/edit"
  get "infusion_pages/camps"
  get "infusion_pages/update"
  get "infusion_pages/credit_card"
  get "infusion_pages/subscription"
  get "infusion_pages/add_subscription"
  get "infusion_pages/update_subscription"
  get "infusion_pages/end_subscription"
  get "infusion_pages/delete_user"
  get "infusion_pages/audit"
  get "infusion_pages/tag_contact"
end

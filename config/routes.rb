MathPlus::Application.routes.draw do

  root to: 'static_pages#home'

  resources :activities do
    collection { post :import }
  end

  resources :avatars

  resources :badge_categories

  resources :badge_requests do
    collection { get :approval }
  end

  resources :badges do
    collection { get :write_up_required }
  end

  resources :class_sessions, only: [:new, :create, :destroy]
  post "class_sessions/start_class"
  get "class_sessions/end_class"
  get "class_sessions/remove_student"

  resources :courses do
    collection { post :import }
  end

  resources :daily_location_reports

  resources :devise

  devise_for :users, :skip => [:registrations]
    as :user do
      get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
      put 'users' => 'devise/registrations#update', :as => 'user_registration'
      put 'users' => 'devise/registrations#update', :as => 'user_registration'
    end

  match '/emails',     to: 'emails#new',             via: 'get'
  resources "emails", only: [:new, :create]

  resources :experiences do
    collection { post :import }
  end

  resources :experience_points
  post 'experience_points/points_lookup', to: 'experience_points#points_lookup'

  resources :enrollment_change_requests do
    collection { get :email }
  end

  resources :grades

  namespace :infusion_pages do
    get :home
    get :add_contact
    get :add_existing_id
    get :possible_contacts
    get :edit
    get :camps
    get :update
    get :credit_card
    get :subscription
    get :add_subscription
    get :update_subscription
    get :end_subscription
    get :delete_user
    get :audit
    get :tag_contact
  end

  resources :issues

  resources :leads do
    resources :notes
  end

  resources :lessons do
    collection { post :import }
  end

  resources :locations do
    collection do
      post :import
      get :list
    end
  end

  resources :messages

  resources :notes
  post 'notes/completed', to: 'notes#completed'

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

  get  'opportunities/by_status', to: 'opportunities#by_status'
  post 'opportunities/update_status', to: 'opportunities#update_status'


  namespace :operations_pages do
      get :main
      get :trial_applet
      get :creating_an_opportunity
  end

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

  resources :problems do
    collection { post :import }
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

  resources :reports
  get 'reports/', to: 'reports#new'
  post 'reports/display', to: 'reports#show'

  resources :resources do
    collection { post :import }
  end

  resources :stages

  resources :standards do
    collection { post :import }
  end

  get 'mission_lookup', to: 'static_pages#mission_lookup'
  get 'code', to: 'static_pages#enter_code'
  post 'static_pages/mission_lookup', to: 'static_pages#mission_lookup'
  get 'thank_you', to: 'static_pages#thank_you'
  get 'badge_home', to: 'static_pages#badges'

  resources :strategies

  resources :students do
    collection do
      post :import
      post :create_from_opportunity
    end
    resources :notes
  end
  get 'students/attended_first_class', to: 'students#attended_first_class'
  post 'students/update_credits', to: 'students#update_credits'

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
      get   :confirmation_opt_out
    end
    resources :notes
  end

  post 'users/deactivate/:id', to: 'users#deactivate'

  resources :videos


  get "binders/briefcase"
  get "binders/middleschool"
  get "schedules/powell"
  get "schedules/new_albany"
end

class SubdomainConstraint
  def matches?(request)
    case request
    when !request.subdomain.present?
      false
    when request.subdomain == 'www'
      false
    else
      true
    end
  end
end

MathPlus::Application.routes.draw do

  constraints(SubdomainConstraint.new) do
    root to: 'static_pages#landing'
  end

  root to: 'static_pages#home'

  resources :activities do
    collection { post :import }
  end

  resources :appointments

  resources :assignments

  resources :attendances

  resources :avatars

  resources :badges do
    collection do
      get :write_up_required
      get :faq
    end
  end

  resources :badge_categories

  resources :badge_modules

  resources :badge_requests do
    collection { get :approval }
  end

  resources :class_sessions, only: [:new, :create, :destroy]
  post "class_sessions/start_class"
  get "class_sessions/end_class"
  get "class_sessions/remove_student"

  resources :companies

  resources :courses do
    collection { post :import }
  end

  resources :daily_location_reports

  resources :devise

  devise_for :users, :skip => [:registrations]
    as :user do
      get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
      put 'users' => 'devise/registrations#update', :as => 'user_registration'
    end

  get  'view_email', to: 'emails#show'

  resources :experiences do
    collection { post :import }
  end

  resources :experience_points do
    collection { get :qc }
  end
  post 'experience_points/points_lookup', to: 'experience_points#points_lookup'

  resources :enrollment_change_requests do
    collection { get :email }
  end

  resources :grades

  post "help_sessions/start_help_session"
  get "help_sessions/end_hw_help"
  get "help_sessions/active_session", to: "help_sessions#active_session"

  resources :help_session_records

  namespace :infusion_pages do
    get :add_to_terimination_sequence
    get :registration_audit
    get :subscription_audit
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

  resources :issues do
    collection do
      get :resolved
    end
  end

  resources :leads do
    resources :notes
  end

  resources :learning_plans

  resources :lessons do
    collection do
      post :import
      get :toggle_error
    end

    resources :notes
  end

  resources :locations do
    collection do
      post :import
      get :list
    end
    member do
      get :registered_students
    end
  end

  resources :messages do
    collection {get :update_status}
  end

  resources :notes
  post 'notes/completed', to: 'notes#completed'

  resources :occupation_levels do
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
      get :course_id
      post :import
      get :offerings_by_location
      get :at_capacity
      get '/:id/attendance_report', to: 'offerings#attendance_report'
    end
  end

  resources :offering_histories

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
      get :analytics
      get :trial_date
      get :attended_trial
      get :missed_trial
      get :add_to_class
      get :update_interest
      post :add_trial
      get :add_trial
      get :join_class
      get :data, defaults: { format: 'json' }
      get :aging_data, defaults: { format: 'json' }
    end
  end

  resources :problems do
    collection { post :import }
  end

  resources :products do
    collection do
      get :products_by_location
      get :update_quantity
    end
  end
  get 'update_quantity', to: 'products#update_quantity'

  resources :registrations do
    collection do
      post :switch
      get :hold
      get :drop
      get :cancel_hold
      get :cancel_drop
      get :attended_first_class
      get :activate
    end
  end

  resources :reports
  get 'reports/', to: 'reports#new'
  post 'reports/display', to: 'reports#show'

  resources :resources do
    collection { post :import }
  end

  resources :sessions, only: [:index, :new]
  get "/auth/:provider/callback" => 'sessions#create'

  resources :stages

  resources :standards do
    collection { post :import }
  end

  get 'mission_lookup', to: 'static_pages#mission_lookup'
  get 'home', to: 'static_pages#home'
  get 'application_lookup', to: 'static_pages#application_lookup'
  get 'code', to: 'static_pages#enter_code'
  get 'events', to: 'static_pages#events'
  get 'event_enrollment', to: 'static_pages#event_enrollment'
  post 'static_pages/mission_lookup', to: 'static_pages#mission_lookup'
  get 'thank_you', to: 'static_pages#thank_you'
  get 'badge_home', to: 'static_pages#badges'
  get 'sample_student', to: 'static_pages#sample_student'

  resources :strategies

  resources :students do
    member do
      get 'badges'
    end
    collection do
      get :change_current_occupation
      get :last_attendance
      post :import
      post :create_from_opportunity
    end

    resources :assignments
    resources :notes
  end
  get 'students/attended_first_class', to: 'students#attended_first_class'
  post 'students/update_credits', to: 'students#update_credits'

  resources :transactions

  resources :users do
    collection do
      post  :create_from_opportunity
      post  :import
      get   :my_account
      get   :password_reset
      get   :send_hold_form
      get   :send_termination_form
      post  :infusion_request
      post  :restart_request
      post  :retention_call
      get   :missed_appointment
      post  :appointment_reschedule_request
      get   :year_end_promotion
      get   :promotion
      post  :appointment_request_new
      get   :confirmation_opt_out
      get   :hide_badge_banner
      get   :show_badge_banner
      get   :new_parent
      get   :new_employee
      get   'edit_parent', to: 'users#edit_parent'
      get   'edit_employee', to: 'users#edit_employee'
    end
    resources :notes
  end

  post 'users/deactivate/:id', to: 'users#deactivate'

  resources :videos


  get "binders/briefcase"
  get "binders/middleschool"
  get "schedules/powell"
  get "schedules/new_albany"
  get "schedules/mill_run"
end

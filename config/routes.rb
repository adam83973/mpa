MathPlus::Application.routes.draw do

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


  root to: 'static_pages#home'

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
  get 'leads/stage_list', to: 'leads#stage_list'
  post 'leads/update_stage', to: 'leads#update_stage'
  post 'experience_points/points_lookup', to: 'experience_points#points_lookup'
  post 'students/update_credits', to: 'students#update_credits'
  post 'notes/completed', to: 'notes#completed'
  post 'users/deactivate/:id', to: 'users#deactivate'
  get 'students/attended_first_class', to: 'students#attended_first_class'
  post 'static_pages/mission_lookup', to: 'static_pages#mission_lookup'
  get 'mission_lookup', to: 'static_pages#mission_lookup'
  get 'code', to: 'static_pages#enter_code'

  resources :leads do
    resources :notes
  end

  resources :students do
    collection do
      post :import
    end
    resources :notes
  end

  resources :experiences do
    collection { post :import }
  end

  resources :users do
    collection do
      post :import
      get :my_account
    end
    resources :notes
  end

  resources :locations do
    collection { post :import }
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
    collection { post :import }
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
end

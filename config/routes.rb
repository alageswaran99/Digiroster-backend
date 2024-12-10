Rails.application.routes.draw do
  resources :notes
  resources :holidays
  resources :groups
  devise_for :users, controllers: { sessions: 'users/sessions', passwords: 'users/passwords' }
  
  resources :appointments do
    collection do
      get :carer, to: 'appointments#carer_appointments'
      post :create_recurring
      get :index_recurring
    end
    member do
      delete :destroy_recurring
      put :update_recurring
      get :recurring
      post :update_progress
      post :close_appointment
      post :cancel_appointment
    end
  end
  resources :clients do
    member do
      put :boarding_docs
      delete :delete_docs
    end
  end
  resources :agents do
    member do
      put :boarding_docs
      post :change_password
      delete :delete_docs
    end
  end
  resources :roles, only: [:index, :show] do
    collection do
      get :specific_roles
    end
  end

  resources :accounts, only: [:none] do
    collection do
      get :dashboard
    end
  end
  #un-used as of now
  # resources :users
  resources :regions
  resources :feedbacks

  resources :invoices do  
    collection do
      post :create, to: 'invoices#create'
      get :index, to: 'invoices#index'
    end
    member do
      put :update, to: 'invoices#update'
    end
  end

  resources :salaries, only: [:create, :update, :destroy, :index] do
    collection do
      get :current_carer_id, to: 'salaries#current_carer_id'  # Custom route for fetching the current carer ID
    end
    member do
      post :generate_salary, to: 'salaries#generate_salary' # Route for generating salary
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.is_admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, controllers: {
    sessions:       'users/sessions',
    passwords:      'users/passwords',
    confirmations:  'users/confirmations',
    passwords:      'users/passwords',
    # omniauth_callbacks: 'users/omniauth_callbacks'
  }, skip: :registrations
  devise_scope :user do
    resource :registration,
      only: [:new, :create, :edit, :update],
      path: :users,
      path_names: { new: 'sign_up' },
      controller: 'users/registrations',
      as: :user_registration
  end

  namespace :admin do
    resources :observers, except: [:index] do
      member do
        post :start
        post :pause
        get  :events
      end

      resource :observer_senders, only: [], path: :senders, as: :senders do
        collection do
          get :edit
          put :update
        end
      end
    end

    resources :senders
    resource  :profiles, only: [:edit, :update]

    root 'home#index'
  end
end

Rails.application.routes.draw do
  namespace :main do
    resources :contacts, only: %i[new create]
    resources :dashboard, only: %i[index]
    resource :employee, only: %i[edit update]
    resources :feedback, only: %i[index]
    resources :high5, only: %i[index new create] do
      collection do
        post :search
      end
    end
    resources :notes
    resources :ranking, only: %i[show]
  end

  namespace :admin do
    resources :dashboard, only: %i[index]
    resources :feedback, only: %i[index update] do
      resources :replies, only: %i[create]
      resources :reminders, only: %i[create]
    end
    resources :high5, only: %i[index show new create] do
      collection do
        post :search
      end
    end
    resources :notes
    resources :polls do
      member do
        put :toggle
      end
    end
    resources :ranking, only: [] do
      collection do
        get 'teams'
        get 'employees'
      end
    end
    resources :trends, only: [] do
      collection do
        get 'global'
      end
    end
    resources :votes, only: :index

    resources :employees do
      resource :permission, only: %i[update destroy]
      resource :archive, only: %i[update destroy]
      collection do
        post :search
      end
    end
    resources :jobs, only: %i[create destroy]
    resources :companies, only: %i[show edit update destroy] do
      resources :deliveries, only: %i[index update]
      resource :slack, only: %i[show update destroy], controller: :slack
    end
    resources :uploads, only: %i[new create]
    resources :teams
    resource :remove, only: %i[show destroy]

    # gamification
    resources :events
    resources :rules do
      resources :conditions
    end
    resources :rewards
    resources :activities, only: %i[index]
    resources :achievements, only: %i[index]
    resources :test_emails do
      collection do
        post :feedback_request
      end
    end
  end

  namespace :api, defaults: { format: :json } do
    namespace :v3 do
      resource :company, only: %i[show]
      resource :dashboard, only: %i[show], controller: :dashboard
      resources :high5, only: %i[index create], controller: :high5
      resources :feedback, only: %i[index create]
      resources :notes, path: '1on1'
      resources :teams, except: %i[destroy]
      resources :employees, except: %i[destroy]
      get 'next_vote/:id', to: 'next_vote#show', as: :next_vote
    end
    resource :slack, only: [], controller: :slack do
      collection do
        post :high5
        post :feedback
        post :report
        post '1on1', to: 'slack#one2one'
        get :auth
      end
    end
  end

  resources :features do
    get 'employee-feedback', to: 'features#feedback'
  end

  namespace :es do
    get '', to: 'spanish#index'
    get 'caracteristicas', to: 'features#index'
    get 'slack', to: 'slack#index'
    get 'precio', to: 'price#index'
    get 'contactar', to: 'contact#index'
    get 'condiciones-uso', to: 'privacy#index'
    get 'politica-privacidad', to: 'privacy#policy'
  end

  resources :companies, only: %i[new create]
  resources :user_sessions, only: %i[create]
  resources :password_resets, only: %i[new create edit update]
  resources :users do
    member do
      get :activate
    end
  end

  get 'polls/:company/:slug', to: 'poll_votes#new', as: :new_poll_vote
  post 'polls/:company/:slug', to: 'poll_votes#create', as: :poll_votes
  get 'vote/:id/:status', to: 'votes#new', as: :new_vote
  post 'votes', to: 'votes#create'
  post '/graphql', to: 'graphql#execute'
  get 'login' => 'user_sessions#new', as: :login
  get 'main', to: redirect('/main/dashboard')
  get 'admin', to: redirect('/admin/dashboard')
  post 'logout' => 'user_sessions#destroy', as: :logout

  root to: 'home#index'
end

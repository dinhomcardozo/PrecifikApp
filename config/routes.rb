Rails.application.routes.draw do
  devise_for :user_clients,
    path:       'clients',
    class_name: 'SystemAdmins::UserClient',
    path_names: {
      sign_in:  'entrar',
      sign_out: 'sair',
      sign_up:  'cadastrar'
    },
    controllers: {
      sessions:      'clients/sessions',
      registrations: 'clients/registrations'
    }

  devise_for :clients,
              class_name: 'SystemAdmins::UserClient',
              path: 'clients',
              controllers: { sessions: 'clients/sessions' }

  root to: 'home#index'

  devise_for :user_admins,
    class_name: 'SystemAdmins::UserAdmin',
    path:      'system_admins/user_admins'

  authenticate :user_admin do
    namespace :system_admins do
      root to: 'user_admins#index', as: :admin_root

      resources :user_admins
      resources :user_clients
      resources :plans
      resources :banners
      resources :clients, only: %i[new create]
    end
  end

  scope path: 'clients', module: 'clients' do
    resource :settings, only: [:show]
  end

  authenticate :user_client do
    scope path: 'clients' do

      scope module: 'clients' do
        root to: 'dashboards/overview#index', as: :clients_root

        resources :user_clients
        
        scope path: 'dashboards', as: 'dashboards' do
          get 'overview', to: 'dashboards/overview#index', as: :overview
        end

        resource :complete_registration,
                 only: %i[new create],
                 path: 'cadastrar/completar',
                 controller: 'clients/complete_registrations'
      end

      # 2) CONTROLLERS EM app/controllers/ (no root)
      resources :products, shallow: true do
        resources :product_subproducts, only: %i[create update destroy]
        collection do
          get :tab
          get :search
        end
      end

      resources :subproducts do
        collection do
          get :search
        end
        member do
          get   :composicao, action: :edit_composition
          patch :composicao, action: :update_composition
        end
      end

      resources :subproduct_compositions,
                path: 'composicao',
                only: %i[create update destroy show]

      resources :inputs do
        collection { get :search }
      end

      resources :input_types

      resources :brands do
        collection { get :search, to: 'brands#search', as: :search }
      end

      resources :suppliers
      resources :channels
      resources :taxes
      resources :sales_targets
      resources :fixed_costs
      resources :categories

      # serviços também fora de clients/, mas em module services/
      scope path: 'clients/services',
            module: 'services',
            as: 'services' do
        root to: 'services#index'
        resources :equipments, shallow: true
        resources :roles,      shallow: true
        resources :services
      end
    end
  end

  unauthenticated do
    root to: redirect('/clients/entrar'), as: :public_root
  end
end
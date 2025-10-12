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

  root to: redirect('/clients')

  devise_for :user_admins,
    class_name: 'SystemAdmins::UserAdmin',
    path: 'system_admins',
    path_names: { sign_in: 'entrar', sign_out: 'sair' },
    skip: [:registrations],
    controllers: {
      sessions: 'system_admins/user_admins/sessions'
    }

  namespace :system_admins do
    root to: 'user_admins#index'
      resources :user_admins
      resources :user_clients
      resources :plans, only: [:index, :show, :new, :create]
      resources :banners
      resources :clients
      resources :messages
  end  

  authenticate :user_admin do
    namespace :system_admins do
      root to: 'user_admins#index', as: :admin_root
      resources :user_clients
      resources :plans, only: [:index, :show, :new, :create]
      resources :banners
      resources :clients
      resources :messages
    end
  end

  scope path: 'clients', module: 'clients' do
    resource :settings, only: [:show]

    get  'cadastrar/completar/new', to: 'complete_registrations#new',   as: :new_complete_registration
    post 'cadastrar/completar',     to: 'complete_registrations#create', as: :complete_registration
    get 'check_cnpj', to: 'complete_registrations#check_cnpj'
  end

  authenticate :user_client do
    scope path: 'clients' do

      scope module: 'clients' do
        namespace :sales do
          resources :price_lists do
            resources :price_list_rules, only: [:new, :create, :edit, :update, :destroy]
            member do
              post :duplicate
              patch :activate
              patch :deactivate
            end
          end
        end

        root to: 'dashboards/overview#index', as: :clients_root

        resources :user_clients, only: [:new, :create, :edit, :show, :update, :destroy]

        resource :settings, only: [:show]

        resources :packages
        resources :product_portions
        resources :channel_product_portions, only: [:show, :update]
        resources :portion_packages
        
        scope path: 'dashboards', as: 'dashboards' do
          get 'overview', to: 'dashboards/overview#index', as: :overview
        end
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

      resources :messages, only: [:index, :show]
      resources :suppliers
      resources :channels
      resources :taxes
      resources :fixed_costs
      resources :categories
      resources :sales_targets do
        collection do
          get :alert_data
        end
      end

      resources :production_simulations do
        member do
          get :production_sheet, defaults: { format: :pdf }
        end
        collection do
          get :calculate
        end
      end

      scope path: 'services', module: 'services', as: 'clients_services' do
        resources :services
        resources :energies
        resources :equipments
        resources :professionals
        resources :roles
        resources :inputs, only: [:show]
        resources :products, only: [:show]
        resources :subproducts, only: [:show]
      end
    end
  end

  unauthenticated do
    root to: redirect('/clients/entrar'), as: :public_root
  end
end
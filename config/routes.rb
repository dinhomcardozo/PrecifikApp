Rails.application.routes.draw do
  namespace :services do
    resources :equipments, shallow: true
    resources :energies, shallow: true
    resources :roles, shallow: true
    resources :professionals, shallow: true

    resources :services,
              path: "",
              as:     :services,
              only:   %i[index show new create edit update destroy] do
      resources :service_professionals, path: "professionals"
      resources :service_energies,      path: "energies"
      resources :service_equipments,    path: "equipments"
      resources :service_inputs,        path: "inputs"
      resources :service_subproducts,   path: "subproducts"
      resources :service_products,      path: "products"
    end
  end

  namespace :sales do
    resources :clients

    resources :quotes do
      member do
        post :calculate_total
      end
    end

    resources :orders
  end

  resources :taxes
  root "products#index"
  
  resources :fixed_costs
  resources :channels
  resources :sales_targets

  # Produtos e subprodutos aninhados
  resources :products do
    resources :product_subproducts, only: %i[create update destroy]
    collection do
      get :tab
    end
  end

  # Marcas, Fornecedores, Tipos de Input, Inputs
  resources :brands
  resources :suppliers
  resources :input_types
  resources :inputs do
    collection { get :search }
  end

  # Subprodutos
  resources :subproducts do
    # 1) Tela de edição da composição
    member do
      get   :composicao, action: :edit_composition,   as: :edit_composition
      patch :composicao, action: :update_composition, as: :update_composition
    end

    # 2) Itens da composição (nested resource)
    resources :subproduct_compositions,
              path: "composicao",
              only: %i[create update destroy show]
  end
end
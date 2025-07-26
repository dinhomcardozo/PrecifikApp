Rails.application.routes.draw do
  resources :taxes
  root "products#index"
  
  resources :product_tax_overrides
  resources :tax_profiles
  
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

  resources :packages do
    resources :package_compositions, only: %i[create update destroy]
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
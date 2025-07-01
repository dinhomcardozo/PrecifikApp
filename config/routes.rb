# config/routes.rb
Rails.application.routes.draw do
  root "products#index"

  # === Produtos e subprodutos aninhados ===
  resources :products do
    resources :product_subproducts, only: %i[create update destroy]
  end

  # === Marcas, fornecedores, tipos de input e inputs ===
  resources :brands
  resources :suppliers
  resources :input_types

  resources :inputs do
    collection do
      get :search
    end
  end

  # === Subprodutos e sua composição ===
  resources :subproducts do
    collection do
      get  "new_simple",     to: "subproducts#new"
      post "create_simple",  to: "subproducts#create"
    end

    member do
      get   "composicao",         to: "subproducts#edit_composition",   as: "edit_composition"
      patch "composicao",         to: "subproducts#update_composition", as: "update_composition"
    end

    resources :subproduct_compositions, only: %i[create update destroy]
  end

  get "criar-subproduto/composicao/:id",
      to:   "subproducts#edit_composition",
      as:   "new_subproduct_composition"
end
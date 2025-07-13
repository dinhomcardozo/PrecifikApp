Rails.application.routes.draw do
  root "products#index"

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
    #   GET  /subproducts/:id/composicao => edit_composition
    #   PATCH/PUT /subproducts/:id/composicao => update_composition (se precisar)
    member do
      get   :composicao, action: :edit_composition,   as: :edit_composition
      patch :composicao, action: :update_composition, as: :update_composition
    end

    # 2) Itens da composição (nested resource)
    #    POST   /subproducts/:subproduct_id/composicao
    #    PATCH  /subproducts/:subproduct_id/composicao/:id
    #    DELETE /subproducts/:subproduct_id/composicao/:id
    resources :subproduct_compositions,
              path: "composicao",
              only: %i[create update destroy show]
  end
end
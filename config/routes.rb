Rails.application.routes.draw do
  root "products#index"

  resources :products do
    collection do
      get :search
    end
  end

  resources :brands
  resources :suppliers
  resources :input_types

  resources :inputs do
    collection do
      get :search
    end
  end

  resources :subproducts do
    # Rotas alternativas para criação simples de subproduto
    collection do
      get 'new_simple', to: 'subproducts#new'
      post 'create_simple', to: 'subproducts#create'
    end

    # Rotas member com URL personalizada para a tela de composição
    member do
      get 'composicao', to: 'subproducts#edit_composition', as: 'edit_composition'
      patch 'composicao', to: 'subproducts#update_composition', as: 'update_composition'
    end

    # Rotas para manipulação (criar, atualizar, deletar) dos insumos (composições) via Turbo Stream
    resources :subproduct_compositions, only: [:create, :update, :destroy]
  end

  # Rota alternativa para a tela de composição (opcional)
  get 'criar-subproduto/composicao/:id', to: 'subproducts#edit_composition', as: 'new_subproduct_composition'
end
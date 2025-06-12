# config/routes.rb

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
    collection do
      get 'new_simple', to: 'subproducts#new'
      post 'create_simple', to: 'subproducts#create'
    end

    member do
      get 'composicao', to: 'subproducts#edit_composition', as: 'edit_composition'
      patch 'composicao', to: 'subproducts#update_composition', as: 'update_composition'
    end
  end

  # Rota alternativa para tela de composição (opcional, mas pode ser removida)
  get 'criar-subproduto/composicao/:id', to: 'subproducts#edit_composition', as: 'new_subproduct_composition'

end
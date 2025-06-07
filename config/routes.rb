Rails.application.routes.draw do
  resources :products do
    collection do
      get :search
    end
  end

  resources :subproducts do
    resources :subproduct_inputs, except: [:show]
  end

  resources :inputs do
    collection do
      get :search
    end
  end

  resources :brands
  resources :suppliers
  resources :input_types
end
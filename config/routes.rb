# config/routes.rb

Rails.application.routes.draw do
  root "products#index"
  
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
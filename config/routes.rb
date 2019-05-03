Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :checklists, except: %i[new] do
    resources :items, only: %i[create update destroy]
  end

  resources :checklist_templates do
    resources :template_items, only: %i[create update destroy]
    member do
      post :create_checklist
    end
  end

  # Item states
  post 'item_states/create/:id', to: 'item_states#create', as: :item_complete
  delete 'item_states/destroy/:id', to: 'item_states#destroy', as: :item_undo
end

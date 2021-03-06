Rails.application.routes.draw do
   devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :checklists do
    resources :show, only: [:index]

    resources :items, only: %i[new create update destroy] do
      resource :item_resolutions, only: [:create, :destroy]
    end
  end

  resources :checklist_templates do
    resources :show, only: [:index]
    resources :template_items, only: %i[create update destroy]
    resource :checklist_copy, only: %i[create]
  end

  resources :users do
    resources :checklist_templates, module: 'users', only: %i[index show]
  end

end

require 'sidekiq/web'

Rails.application.routes.draw do
  root 'dashboards#show'
  devise_for :admins, controllers: { sessions: 'admin/sessions' }
  devise_for :users, controllers: { sessions: 'users/sessions', omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users, only: %i[show edit update] do
    resources :recommended_posts, only: [:index]
  end

  resources :posts, except: [:index] do
    resources :responses, only: [:create]
  end

  resources :tags, only: [:show]

  get 'me/bookmarks' => 'dashboards#bookmarks', as: :dashboard_bookmarks
  get 'top-posts' => 'dashboards#top_posts', as: :top_posts
  get 'me/drafts' => 'drafts#drafts', as: :drafts
  get 'me/public' => 'drafts#published', as: :published
  get 'search' => 'search#show', as: :search
  get 'search/users' => 'search#users', as: :search_users
  post 'posts/create_and_edit' => 'posts#create_and_edit', as: :post_create_and_edit

  namespace :admin do
    resource :dashboard, only: [:show]
    resources :featured_tags, only: %i[create destroy]
    resources :featured_posts, only: %i[create destroy]
  end

  namespace :api do
    resources :notifications, only: [:index] do
      post :mark_as_touched, on: :collection
      post :mark_all_as_read, on: :collection
      post :mark_as_read, on: :member
    end

    get 'autocomplete' => 'search_autocomplete#index'

    resources :posts, only: %i[create update destroy]
    resources :users, only: [:show]
    resources :likers, only: [:index]
    resources :tag_followers, only: [:index]
    resources :followers, only: [:index]
    resources :following, only: [:index]
    resources :following_tags, only: [:index]
    resources :tags, only: [:create]
    resources :follow_suggestions, only: [:index]

    resources :posts, only: [] do
      resource :likes, only: %i[create destroy], module: :posts
      resource :bookmarks, only: %i[create destroy], module: :posts
    end

    resources :responses, only: [] do
      resource :likes, only: %i[create destroy], module: :responses
      resource :bookmarks, only: %i[create destroy], module: :responses
    end

    post    'relationships' => 'relationships#create'
    delete  'relationships' => 'relationships#destroy'
    post    'interests' => 'interests#create'
    delete  'interests' => 'interests#destroy'
  end

  authenticate :admin do
    mount Sidekiq::Web => '/sidekiq'
  end
end

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  
  resources :posts do
    resources :comments, only: [:create, :show, :index] 
  end
#cond
  authenticate :user do
    resources :posts, only: [:edit, :update, :destroy] do
      resources :comments, only: [:edit, :update, :destroy] 
    end
  end

  root 'posts#index'
end

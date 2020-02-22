Rails.application.routes.draw do
  namespace :admin do
    resources :employees, only: %i[index create update destroy show]
    resources :performance_evaluations, only: %i[index create update destroy show]
    resource :admin_user, only: :create
  end

  namespace :employee do
    resources :performance_evaluations, only: :index
  end
end

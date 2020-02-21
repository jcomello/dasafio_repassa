Rails.application.routes.draw do
  namespace :admin do
    resource :employees, only: %i[create update destroy show]
    resource :performance_evaluations, only: :create
  end
end

Rails.application.routes.draw do
  namespace :admin do
    resource :employees, only: :create
  end
end

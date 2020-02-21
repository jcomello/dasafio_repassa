Rails.application.routes.draw do
  namespace :admin do
    resource :employees, only: %i[create update]
  end
end

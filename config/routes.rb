Rails.application.routes.draw do
  resources :daily_reports, only: :index do
    collection do
      get :latest
    end
  end

  root to: redirect('/daily_reports')
end

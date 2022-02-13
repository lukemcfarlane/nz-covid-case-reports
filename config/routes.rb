Rails.application.routes.draw do
  resources :daily_reports, only: :index do
    collection do
      get :latest
      post :check_for_updates
    end
  end

  root to: redirect('/daily_reports')
end

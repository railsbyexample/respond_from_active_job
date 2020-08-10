Rails.application.routes.draw do
  resources :process_runs, only: %i[index create show]

  root to: redirect('/process_runs')
end

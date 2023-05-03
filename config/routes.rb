Rails.application.routes.draw do
  get '/issues/bulkForm', to: 'issues#bulkCreate', as: 'issues_bulkForm'
  get '/issues/bulk', to: 'issues#bulk', as: 'bulk_issue'
  post '/issues/bulkForm', to: 'issues#bulkCreate', as: 'issues_bulkForm_post'

  resources :issue_user_modifications
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  resources :issues do
    resources :comments, only: [:create]
  end
  resources :activities
  resources :watchers
  resources :users
  resources :issues, except: [:show]

  resources :issues do
    resources :attachments, only: [:create, :destroy]
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # root 'application#hello'

  # Fa que la pàgina d'inici sigui la del archiu index.html.erb de la carpeta Issues
  root 'issues#index'

  get '/issues/:id/editDueDate', to: 'issues#dueDate', as: 'issue_dueDate'
  put '/issues/:id/dueDate', to: 'issues#updateDueDate'
  patch '/issues/:id/dueDate', to: 'issues#updateDueDate', as: 'issue_dueDate_edit'

  get '/issues/:id/editBlock', to: 'issues#block', as: 'issue_block'
  put '/issues/:id/block', to: 'issues#updateBlock'
  patch '/issues/:id/block', to: 'issues#updateBlock', as: 'issue_block_edit'

  get '/issues/:id/editWatchers', to: 'issues#watchers', as: 'issue_watchers'
  put '/issues/:id/watchers', to: 'issues#updateWatchers'
  patch '/issues/:id/watchers', to: 'issues#updateWatchers', as: 'issue_watchers_edit'

  get '/issues/:id/editAssigned', to: 'issues#assigned', as: 'issue_assigned'
  put '/issues/:id/assigned', to: 'issues#updateAssigned'
  patch '/issues/:id/assigned', to: 'issues#updateAssigned', as: 'issue_assigned_edit'
end

Rails.application.routes.draw do
  devise_for :users
  root "home#index"
  
  get 'auth/xero_oauth/callback', to: 'xero_oauth#callback'
  
  post :sync_invoices, to: "home#sync_invoices", as: :sync_invoices
  post :disconnect, to: "home#disconnect", as: :disconnect
end

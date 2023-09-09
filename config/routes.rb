Rails.application.routes.draw do
  devise_for :users
  root "home#index"
  
  get 'auth/xero_oauth/callback', to: 'xero_oauth#callback'
  
  post :fetch_invoices, to: "home#fetch_invoices", as: :fetch_invoices
  post :disconnect, to: "home#disconnect", as: :disconnect
end

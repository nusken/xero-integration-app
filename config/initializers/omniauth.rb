Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :xero_oauth2,
    Rails.application.credentials.xero[:client_id],
    Rails.application.credentials.xero[:client_secret],
    scope: 'openid accounting.transactions.read offline_access'
  )
end
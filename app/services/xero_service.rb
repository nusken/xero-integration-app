class XeroService 
  attr_reader :token_set 
  
  def initialize(token_set = {})
    @token_set = token_set
  end
  
  def fetch_invoices 
    xero_client.set_token_set(token_set)
    
    xero_client.accounting_api
  end
  
  def xero_client 
    creds = {
      client_id: Rails.application.credentials.xero[:client_id],
      client_secret: Rails.application.credentials.xero[:client_secret],
      grant_type: 'client_credentials',
      scopes: 'openid accounting.transactions.read offline_access'
    }
    
    @xero_client ||= XeroRuby::ApiClient.new(credentials: creds)
  end
end
class XeroService 
  attr_reader :token_set, :xero_client
  
  class XeroServiceError < StandardError; end
    
  def initialize(token_set = {})
    @token_set = token_set
    
    init_xero_client
  end
  
  def fetch_invoices(tenant_id, &block)
    validate_token_set_presence
    
    page = 1
    
    loop do 
      opts = { page: page }
      
      invoices = fetch_invoices_for_tenant(tenant_id, opts)
      
      break if invoices.empty?
      
      yield(invoices)
      page += 1
    end
  end
  
  def refresh_token 
    new_token_set = xero_client.refresh_token_set(token_set)
    new_token_set["connections"] = xero_client.connections
    
    @token_set = new_token_set
    
    new_token_set
  end
  
  private
  def init_xero_client
    creds = {
      client_id: Rails.application.credentials.xero[:client_id],
      client_secret: Rails.application.credentials.xero[:client_secret],
      redirect_uri: Rails.application.credentials.xero[:redirect_uri],
      scopes: Rails.application.credentials.xero[:scopes],
      state: '1'
    }
    config = { timeout: 30 }
    
    @xero_client ||= XeroRuby::ApiClient.new(credentials: creds, config: config)
  end
  
  def validate_token_set_presence
    raise XeroServiceError, "Missing Xero Token Set" unless token_set.present?
    
    xero_client.set_token_set(token_set)
      
    if xero_client.token_expired?
      new_token_set = refresh_token
      xero_client.set_token_set(new_token_set)
    end
  end
  
  def fetch_invoices_for_tenant(tenant_id, opts)
    xero_client.accounting_api.get_invoices(tenant_id, opts).invoices
  rescue StandardError => e
    # Handle API errors here
    raise XeroServiceError, "Error fetching invoices: #{e.message}"
  end
end
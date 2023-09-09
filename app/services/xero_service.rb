class XeroService 
  attr_reader :token_set 
  
  def initialize(token_set = {})
    @token_set = token_set
  end
  
  def fetch_invoices(tenant_id, &block)
    page = 1
    loop do 
      opts = {
        page: page
      }
      
      invoices = xero_client.accounting_api.get_invoices(tenant_id, opts).invoices
      
      puts "Getting invoices"
      pp(invoices)
      if invoices.present?
        yield(invoices)
        page += 1
      else
        puts "no more invoices"
        break
      end
    end
  end
  
  def xero_client
    creds = {
      client_id: Rails.application.credentials.xero[:client_id],
      client_secret: Rails.application.credentials.xero[:client_secret],
      redirect_uri: Rails.application.credentials.xero[:redirect_uri],
      scopes: Rails.application.credentials.xero[:scopes],
      state: '1'
    }
    config = { timeout: 30 }
    
    @xero_client ||= XeroRuby::ApiClient.new(credentials: creds, config: config)

    if token_set
      puts "Set new token set"
      @xero_client.set_token_set(token_set)
    end

    return @xero_client
  end
  
  def refresh_token 
    new_token_set = xero_client.refresh_token_set(token_set)
    new_token_set["connections"] = xero_client.connections
    
    @token_set = new_token_set
    
    new_token_set
  end
end
class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  helper_method :xero_client
  
  private 
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

    if current_user&.xero_token_set
      @xero_client.set_token_set(current_user.xero_token_set)
    end

    return @xero_client
  end
  
  def refresh_token 
    current_user.xero_token_set = xero_client.refresh_token_set(current_user.xero_token_set)
    current_user.xero_token_set['connections'] = @xero_client.connections
    current_user.save!
  end
end

module ApplicationHelper
  def xero_authorization_url
    @xero_authorization_url ||= xero_client.authorization_url 
  end
end

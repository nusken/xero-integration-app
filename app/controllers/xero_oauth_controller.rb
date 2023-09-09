class XeroOauthController < ApplicationController 
  before_action :xero_client
  
  def callback 
    if params['code']
      @token_set = @xero_client.get_token_set_from_callback(params)
      # you can use `@xero_client.connections` to fetch info about which orgs
      # the user has authorized and the most recently connected tenant_id
      current_user.xero_token_set = @token_set if !@token_set["error"]
      current_user.xero_token_set['connections'] = @xero_client.connections
      current_user.active_tenant_id = latest_connection(current_user.xero_token_set['connections'])
      current_user.save!
      flash.notice = "Successfully received Xero Token Set"
    else
      flash.notice = "Failed to received Xero Token Set"
    end
    
    redirect_to root_path
  end
  
  private
  def latest_connection(connections)
    if !connections.empty?
      connections.sort { |a,b|
        DateTime.parse(a['updatedDateUtc']) <=> DateTime.parse(b['updatedDateUtc'])
      }.first['tenantId']
    else
      nil
    end
  end
end
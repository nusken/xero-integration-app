class HomeController < ApplicationController
  def index
  end
  
  def fetch_invoices
    refresh_token 
    
    @page = params[:page] || 1
    
    opts = {
      page: 1
    }
    
    @tenant_id = params[:tenant_id] || current_user.active_tenant_id
    
    @invoices = xero_client.accounting_api.get_invoices(@tenant_id, opts).invoices
    
    render :index
  end
  
  def disconnect
    current_user.xero_token_set = {}
    current_user.save!
    
    render :index
  end
end

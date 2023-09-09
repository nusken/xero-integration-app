class HomeController < ApplicationController
  def index
    @invoices = current_user.invoices
    
    @page = params[:page] || 1
    
    if params[:tenant_id].present?
      @invoices = @invoices.where(tenant_id: params[:tenant_id])
    end
    
    @invoices = @invoices.page(params[:page])
  end
  
  def sync_invoices
    current_user.refresh_xero_token 
    
    current_user.fetch_invoices_from_xero
    
    flash.notice = "Successfully synced all invoices"
    
    redirect_to root_path
  end
  
  def disconnect
    current_user.xero_token_set = {}
    current_user.save!
    
    render :index
  end
end

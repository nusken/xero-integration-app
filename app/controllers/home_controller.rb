class HomeController < ApplicationController
  def index
    @invoices = Invoice.all
    
    @page = params[:page] || 1
    
    if params[:tenant_id]
      @invoices = @invoices.where(tenant_id: params[:tenant_id])
    end
    
    @invoices = @invoices.page(params[:page])
  end
  
  def sync_invoices
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

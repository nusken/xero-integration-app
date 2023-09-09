class HomeController < ApplicationController
  def index
    @invoices = Invoice.all
    
    if params[:tenant_id]
      @invoices = @invoices.where(tenant_id: params[:tenant_id])
    end
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

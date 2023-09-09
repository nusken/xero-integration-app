class SyncInvoices < ApplicationJob 
  def perform(user_id)
    user = User.find(user_id)
    
    user.fetch_invoices_from_xero
  end
end
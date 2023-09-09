class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  serialize :xero_token_set, Hash 
  
  has_many :invoices
  
  def connected_with_xero?
    !xero_token_set.empty?
  end
  
  def fetch_invoices_from_xero
    return unless connected_with_xero?
    
    xero_service = XeroService.new(xero_token_set)
    
    self.xero_token_set = xero_service.refresh_token
    self.save
    
    # Fetch invoices from each tenant
    xero_token_set["connections"].each do |connection|
      xero_service.fetch_invoices(connection["tenantId"]) do |fetched_invoices|
        fetched_invoices.each do |invoice|
          self.invoices.where(xero_invoice_id: invoice.invoice_id).first_or_create(
            outstanding_amount: invoice.amount_due,
            total_amount: invoice.total,
            due_date: invoice.due_date,
            status: invoice.status,
            client_name: invoice.contact.name,
            contact_id: invoice.contact.contact_id,
            tenant_id: connection["tenantId"]
          )
        end
      end
    end
  end
end

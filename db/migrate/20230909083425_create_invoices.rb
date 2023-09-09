class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.string :xero_invoice_id
      t.string :status
      t.decimal :outstanding_amount
      t.decimal :total_amount
      t.date :due_date
      t.string :client_name
      t.string :contact_id
      t.string :tenant_id
      
      t.integer :user_id

      t.timestamps
    end
  end
end

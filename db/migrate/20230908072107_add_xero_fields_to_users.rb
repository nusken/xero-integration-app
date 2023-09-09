class AddXeroFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :xero_token_set, :text
    add_column :users, :active_tenant_id, :string
  end
end

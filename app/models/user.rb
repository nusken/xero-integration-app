class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  serialize :xero_token_set, Hash 
  
  def connected_with_xero?
    !xero_token_set.empty?
  end
  
  def fetch_xero_invoices
    @invoices ||= XeroService.new(xero_access_token, xero_refresh_token).fetch_invoices
  end
end

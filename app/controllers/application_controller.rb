class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  helper_method :xero_client
  
  private 
  def xero_client
    @xero_client ||= XeroService.new.xero_client
  end
end

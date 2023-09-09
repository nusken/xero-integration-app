module ApplicationHelper
  require 'jwt'

  def token_expired
    # token_expiry = Time.at(access_token['exp'])
    # exp_text = time_ago_in_words(token_expiry)
    # puts "token_expiry #{token_expiry}"
    # puts "Time.now #{Time.now}"    
    # token_expiry > Time.now ? "in #{exp_text}" : "#{exp_text} ago" 
    xero_client.token_expired?
  end

  def id_token
    JWT.decode(current_user.token_set['id_token'], nil, false)[0] if current_user && current_user.token_set
  end

  def access_token
    JWT.decode(current_user.token_set['access_token'], nil, false)[0] if current_user && current_user.token_set
  end

  def has_token_set?
    unless current_user
      if current_user && current_user.xero_token_set
        redirect_to authorization_url
        return
      else
        redirect_to '/users/new'
        return
      end
    end
  end

  def xero_authorization_url
    @xero_authorization_url ||= xero_client.authorization_url 
  end

  def pretty_json(data)
    raw "<pre><code>#{JSON.pretty_generate(JSON.parse(data))}</code></pre>"
  end
end

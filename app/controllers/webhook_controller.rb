class WebhookController < ApplicationController
skip_before_filter  :verify_authenticity_token

def start
logger.info "#{Time.now}  WebhookControllerDomain1 #{params[:domain].inspect}"
require 'rubygems'
require 'base64'
require 'openssl'


  def verify_webhook(data, hmac_header)
    calculated_hmac = Base64.strict_encode64(OpenSSL::HMAC.digest('sha256', "f65fb66d067a07d8b71387e5d84ff959", data))
	if calculated_hmac == hmac_header
	#User.where(shop_url: params[:domain]).destroy_all
	logger.info "#{Time.now}  WebhookControllerDomainRedirect  /auth/shopify?shop=#{params[:domain]}"
	session[:shopify] = nil
	redirect_to "/auth/shopify?shop=#{params[:domain]}"
	end
    
  end
  
data = request.body.read
verified = verify_webhook(data, env["HTTP_X_SHOPIFY_HMAC_SHA256"])

end
end
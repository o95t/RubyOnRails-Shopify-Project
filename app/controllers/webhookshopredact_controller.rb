class WebhookshopredactController < ApplicationController
skip_before_filter  :verify_authenticity_token

def start
logger.info "#{Time.now}  WebhookshopredactController #{params[:domain].inspect}"
require 'rubygems'
require 'base64'
require 'openssl'

  def verify_webhook(data, hmac_header)
    calculated_hmac = Base64.strict_encode64(OpenSSL::HMAC.digest('sha256', "f65fb66d067a07d8b71387e5d84ff959", data))
	if calculated_hmac == hmac_header
	logger.info "#{Time.now}  WebhookshopredactController 200?shop=#{params[:domain]}"
	render :nothing => true, :status => 200
	else
	render :nothing => true, :status => 401
	end
  end
  
data = request.body.read
verified = verify_webhook(data, env["HTTP_X_SHOPIFY_HMAC_SHA256"])

end
end
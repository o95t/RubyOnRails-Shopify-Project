class CheckoutController < ApplicationController
skip_before_filter  :verify_authenticity_token

def start

if env["HTTP_X_SHOPIFY_HMAC_SHA256"].present?

require 'json'
require 'rubygems'
require 'base64'
require 'openssl'
require 'json'

			  def verify_webhook(data, hmac_header)
				calculated_hmac = Base64.strict_encode64(OpenSSL::HMAC.digest('sha256', "f65fb66d067a07d8b71387e5d84ff959", data))
				if calculated_hmac != hmac_header
					abort("Not correct input data.")
				end
			  end
			  
			data = request.body.read
			verified = verify_webhook(data, env["HTTP_X_SHOPIFY_HMAC_SHA256"])
			

			user =  User.find_by_shop_url ActionController::Base.helpers.sanitize(request.env['HTTP_X_SHOPIFY_SHOP_DOMAIN'])
			logger.info "#{Time.now}  CheckOutController #{request.env['HTTP_X_SHOPIFY_SHOP_DOMAIN'].inspect}"
				if ActionController::Base.helpers.sanitize(request.env['HTTP_X_SHOPIFY_SHOP_DOMAIN']) != user.shop_url
					logger.info "#{Time.now}  user.shop_url is not correct #{user.shop_url}"
					abort("Not correct url data.")
				end

				if  user.mode == '' || user.mode == 'true' || user.mode == 'yes'
					logger.info "#{Time.now}  user.mode is not correct #{user.shop_url}"
					abort("Not correct user.mode data.")
				end				

				
					if params[:rate][:origin][:country] == params[:rate][:destination][:country]
						product_group = "DOM"
						default = user.default_domestic_product_type
					else
						product_group = "EXP"
						default = user.default_international_product_type
					end
			output2 = []
			default.each do |p|
					if product_group == "DOM"
						service_name =  Shipment.domestic_product_type_hash.select{|key, hash| hash == p }
					else
						service_name =  Shipment.express_product_type_hash.select{|key, hash| hash == p }
					end

			weight = 0
			params[:rate][:items].each do |item|
			weight= weight + item[:quantity] * item[:grams]
			end
			weight = weight.to_f/1000
			logger.info weight.inspect
				@message_hash = {
						  client_info: 
						  { 
							user_name: user.email,
							password: user.password,
							version: "v1.0",
							account_number: user.account_number,
							account_pin: user.account_pin,
							account_entity: user.account_entity,
							account_country_code: user.country_code
						  },
						  origin_address: {
								line1: params[:rate][:origin][:address1],
								line2: params[:rate][:origin][:address2],
								line3: params[:rate][:origin][:address2],
								city: params[:rate][:origin][:city],
								state_or_province_code: params[:rate][:origin][:province],
								post_code:  params[:rate][:origin][:postal_code],
								country_code: params[:rate][:origin][:country]
							},
						  destination_address: {
								line1: params[:rate][:destination][:address1],
								line2: params[:rate][:destination][:address2],
								line3: params[:rate][:destination][:address2],
								city: params[:rate][:destination][:city],
								state_or_province_code: params[:rate][:destination][:province],
								post_code:  params[:rate][:destination][:postal_code],
								country_code: params[:rate][:destination][:country]
							},
						  shipment_details: {
						  dimensions:
						  {length:"0", width:"0", height:"0", unit:"cm"},
						  actual_weight:{unit:"KG", value: weight},
						  chargeable_weight:{unit:"KG", value: weight},
						  description_of_goods:"xxxxx",
						  goods_origin_country: "JO",
						  number_of_pieces: "1",
						  product_group: product_group,
						  product_type: p,
						  payment_type: "P",
						  payment_options: "",
						number_of_pieces: "1",
							},
							preferred_currency_code: params[:rate][:currency]    			      
					}
							rate_calculator_client = Savon.client do
								wsdl "#{ShopifyAramex::Application.config.rate_calculator_wsdl.to_s}"
								convert_request_keys_to :camelcase
							end 
							logger.info  @message_hash
					@response = rate_calculator_client.call(:calculate_rate, message: @message_hash)
					logger.info  @response.body.inspect

			output2 << {
			service_name: "Aramex: " + service_name.keys.first,
			service_code: p,
			total_price: @response.body[:rate_calculator_response][:total_amount][:value].to_f * 100,
			currency: @response.body[:rate_calculator_response][:total_amount][:currency_code]
			}
			end
			logger.info output2.inspect
			my_object = { :rates => output2 }
			render :json => my_object.to_json
end

end
end
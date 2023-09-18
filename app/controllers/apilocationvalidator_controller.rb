class ApilocationvalidatorController < ApplicationController
skip_before_filter  :verify_authenticity_token

def start

if params[:shop].present?

user =  User.find_by_shop_url ActionController::Base.helpers.sanitize(params[:shop])

logger.info request.headers['origin'].sub(/^https?\:\/\/(www.)?/,'').inspect
logger.info user.mode.inspect

if params[:shop] == user.mode
		@message_hash_applyvalidation = {
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
			address: 
	  		{
	  			line1: "001",
	  			line2: "",
	  			line3: "",
	  			city: params[:city],
	  			state_or_province_code: "",
	  			post_code: params[:post_code],
	  			country_code: params[:country_code]
	  		}
	  	}
	    applyvalidation_client = Savon.client(pretty_print_xml: true, ssl_verify_mode: :none) do
	      wsdl "#{ShopifyAramex::Application.config.location_wsdl}"
	      convert_request_keys_to :camelcase
	    end
	 	@response = applyvalidation_client.call(:validate_address, message: @message_hash_applyvalidation)

  #abort @response.body[:address_validation_response].inspect
			response_arr = []
 			# Check if the reponse has errors
 			if @response.body[:address_validation_response][:has_errors]
 				unless @response.body[:address_validation_response][:suggested_addresses].nil?
			       suggested_address = @response.body[:address_validation_response][:suggested_addresses]
			      else
			        suggested_address = ""
			    end
			    message = @response.body[:address_validation_response][:notifications][:notification][:message]
			    response_arr << [:is_valid, false] 
			    #response_arr << [:suggestedAddresses, suggested_address]
				response_arr << [:suggestedAddresses, "xxxxx"]
				response_arr << [:message, message]
 			else
 				response_arr << [:is_valid, true] 
  			end
headers['Access-Control-Allow-Origin'] = '*'
headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, PATCH, OPTIONS'
headers['Access-Control-Request-Method'] = '*'
headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
		render :json => response_arr.to_json
	end
	end
end
end

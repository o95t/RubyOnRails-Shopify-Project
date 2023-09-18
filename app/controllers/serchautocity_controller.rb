class SerchautocityController < ApplicationController

skip_before_filter  :verify_authenticity_token

def start
#abort request.headers['origin'].inspect

if params[:shop].present?

#logger.info  request.headers['origin'].inspect
#logger.info  request.headers['origin'].sub(/^https?\:\/\/(www.)?/,'')

user =  User.find_by_shop_url ActionController::Base.helpers.sanitize(params[:shop])
logger.info  user.mode.inspect

#abort request.headers.inspect
 if params[:shop] == user.mode
 	@user_hash = {
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
			country_code: ActionController::Base.helpers.sanitize(params[:country_code]),	
			name_starts_with: ActionController::Base.helpers.sanitize(params[:term])	
		}
    
    location_client = Savon.client(pretty_print_xml: true, ssl_verify_mode: :none) do
      wsdl "#{ShopifyAramex::Application.config.location_wsdl}"
      convert_request_keys_to :camelcase
    end
    cities_response = location_client.call(:fetch_cities, message: @user_hash)
headers['Access-Control-Allow-Origin'] = '*'
headers['Access-Control-Allow-Methods'] = '*'
headers['Access-Control-Request-Method'] = '*'
headers['Access-Control-Allow-Headers'] = '*'

if cities_response.body[:cities_fetching_response][:cities][:string].kind_of?(Array)
for_json = cities_response.body[:cities_fetching_response][:cities][:string].to_json
elsif cities_response.body[:cities_fetching_response][:cities][:string] === nil
for_json = nil
else
test = []
test << cities_response.body[:cities_fetching_response][:cities][:string]
for_json = test.to_json
	end
	render json: for_json
	end
end


end
end


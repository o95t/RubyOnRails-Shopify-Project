module PickupsHelper
	def aramex_country_ar
    return cached_countries if cached_countries
    @user_hash = {
      client_info: client_info 
    }
    location_client = Savon.client(pretty_print_xml: true, ssl_verify_mode: :none) do
      wsdl "#{ShopifyAramex::Application.config.location_wsdl}"
      convert_request_keys_to :camelcase
    end
    locations_response = cached_countries  || location_client.call(:fetch_countries, message: @user_hash)
    Rails.cache.write('countries', locations_response.body[:countries_fetching_response][:countries][:country]) unless cached_countries
    return cached_countries
    
    # locations_response = location_client.call(:fetch_countries, message: @user_hash)
    # return locations_response.body[:countries_fetching_response][:countries][:country]
    # render :json => @locations_response.body[:countries_fetching_response][:countries][:country].to_json
  end

  def cached_countries
    @_cached_countries = Rails.cache.read('countries')
  end

  def client_info
    {
      user_name: current_user.email,
      password: current_user.password,
      version: "v1.0",
      account_number: current_user.account_number,
      account_pin: current_user.account_pin,
      account_entity: current_user.account_entity,
      account_country_code: current_user.country_code
    }
  end
end

module OmniauthMacros
	def mock_auth_hash
		OmniAuth.config.mock_auth[:shopify] = {
			'provider' => 'shopify',
			'shop' => 'example-app.myshopify.com',
			'code' => '1234567890',
			'credentials' => {
		        'token' => 'mock_token',
		        'secret' => 'mock_secret'
		    }
      	}
	end
end
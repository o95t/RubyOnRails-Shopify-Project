include ApplicationHelper

# Signups a new user with the default values
def goto_login_page_and_click_install
	visit '/login'
	fill_in "shop", with: "https://example-app.myshopify.com"
	mock_auth_hash
	click_button "Install"
end
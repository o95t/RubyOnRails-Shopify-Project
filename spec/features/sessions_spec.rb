require 'spec_helper'

feature "Sessions" do

	scenario "visit home page without signing in" do
		visit '/'
		expect(page).to have_title('Login - Aramex Shopify App')
	end

  
    scenario "login page should have the content 'Login to Aramex Shopify App'" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit '/login'
      expect(page).to have_content('Login to Aramex Shopify App')
    end

    scenario "signing up via shopify and creating user with aramex details" do	
    	goto_login_page_and_click_install
    	expect(page).to have_title('Add Aramex Account Settings - Aramex Shopify App')

    	fill_in 'Username', with: 'user@example.com'
    	fill_in 'Password', with: 'password'
    	fill_in 'Account Number', with: '123456789'
    	fill_in 'Account Pin', with: '123456'
    	fill_in 'Account Entity', with: 'BOM'
    	fill_in 'Account Country Code', with: 'IN'
    	click_button 'Submit'

    	expect(page).to have_title('Aramex Shopify App')
    	page.should have_content 'Successfully added Aramex account information'
    end

    # scenario "logging in via shopify and visit home without creating account" do
    # 	goto_login_page_and_click_install
    # 	visit '/'
    # 	expect(page).to have_title('Add Aramex Account Settings - Aramex Shopify App')
    # end

    scenario "going to new account page directly without shopify oauth" do 
    	visit new_user_path
    	expect(page).to have_title('Login - Aramex Shopify App')
    end

end
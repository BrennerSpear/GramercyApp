require 'rails_helper'

feature 'Brand inputs initial per-post payment settings' do
	scenario 'with valid numbers' do 
		visit initial_settings_path
		fill_in 'cents per like', with: '5'
		fill_in 'dollars_per_follow', with: '5.00'
		fill_in 'max_total_allowed', with: '100'
		fill_in 'days_to_post', with: '30'
		click_on 'Save and Continue'

		#expect(page).to 

	end
end
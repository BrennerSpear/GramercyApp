Rails.application.config.middleware.use OmniAuth::Builder do
	provider :instagram, ENV['IG_API_KEY'], ENV['IG_SECRET'], scope: 'basic'
	provider :bigcommerce, ENV['BC_CLIENT_ID'], ENV['BC_CLIENT_SECRET'], scope: bc_scopes
	
end

def bc_scopes
	'default users_basic_information store_v2_information store_v2_content store_v2_customers store_v2_settings store_v2_products store_v2_orders store_v2_marketing'
end
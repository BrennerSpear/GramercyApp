Rails.application.config.middleware.use OmniAuth::Builder do
	provider :instagram, ENV['IG_API_KEY'], ENV['IG_SECRET'], scope: 'basic'
	provider :bigcommerce, ENV['BC_CLIENT_ID'], ENV['BC_CLIENT_SECRET'], scope: bc_scopes2
	
end

def bc_scopes
	'default users_basic_information store_v2_information store_v2_content store_v2_customers store_v2_settings store_v2_products store_v2_orders store_v2_marketing'
end

def bc_scopes2
	'store_v2_orders store_v2_products_read_only store_v2_customers_read_only store_v2_content_read_only store_v2_marketing store_v2_information_read_only'
end
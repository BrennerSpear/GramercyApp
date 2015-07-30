json.array!(@leads) do |lead|
  json.extract! lead, :id, :email, :platform
  json.url lead_url(lead, format: :json)
end

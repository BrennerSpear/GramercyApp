uri = URI.parse(ENV.fetch("REDISTOGO_URL"))
REDIS = Redis.new(url: uri)

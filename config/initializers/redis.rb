require "redis"

# $redis = Redis.new host: , port: 6380
host = Rails.application.credentials[Rails.env.to_sym][:redis][:host]
port = Rails.application.credentials[Rails.env.to_sym][:redis][:port]
$redis = Redis.new host: host, port: port

begin
  $redis.ping
rescue Exception => e
  Rails.logger.info { "Error: Redis server unavailable. #{e.message}" }
end

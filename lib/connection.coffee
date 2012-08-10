caboose_redis = require '../index'

class Connection
  @create: (name, callback) ->
    return callback(null, caboose_redis.connections[name]) if caboose_redis.connections[name]?
    
    return callback(new Error('No configuration found for caboose-redis')) unless caboose_redis.configs?
    return callback(new Error("No configuration found for #{name} connection")) unless caboose_redis.configs[name]?
    
    redis = caboose_redis.redis
    
    config = caboose_redis.configs[name]
    
    url_config = require('url').parse(config.url) if config.url?
    [url_username, url_password] = url_config.auth.split(':') if url_config?.auth?
    
    host = url_config?.hostname || config.host || 'localhost'
    port = url_config?.port || config.port || 6379
    username = url_username || config.username
    password = url_password || config.password
    
    client = redis.createClient(port, host)
    client.auth(password) if password?
    
    caboose_redis.connections[name] = client
    
    process.nextTick ->
      callback(null, client)

module.exports = Connection

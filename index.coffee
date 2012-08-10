return module.exports = global['caboose-redis'] if global['caboose-redis']?

caboose = Caboose.exports
util = Caboose.util
logger = Caboose.logger

caboose_redis = global['caboose-redis'] = module.exports =
  connections: {}

  configure: (config) ->
    @configs = {}
    if config.host? or config.url?
      @configs.default = config
    else
      for k, v of config
        @configs[k] = v
    @
  
  connect: (name, callback) ->
    if typeof name is 'function'
      callback = name
      name = 'default'
    
    return callback(new Error('No configuration found for caboose-redis')) unless caboose_redis.configs?
    
    caboose_redis.Connection.create(name, callback)

  'caboose-plugin': {
    install: (util, logger) ->
      # util.mkdir(Caboose.path.app.join('models'))
      util.create_file(
        Caboose.path.config.join('caboose-redis.json'),
        JSON.stringify({host: 'localhost', port: 6379}, null, 2)
      )
    
    initialize: ->
      # Caboose.path.models ?= Caboose.path.app.join('models')
      #       
      #       Caboose.registry.register 'redis', {
      #         get: (parsed_name) ->
      #           
      #       }
      
      if Caboose?.app?.config?['caboose-redis']?
        caboose_redis.configure(Caboose.app.config['caboose-redis'])
  }

caboose_redis.redis = require 'redis'
caboose_redis.Connection = require './lib/connection'

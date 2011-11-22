require 'redis'
require 'mongo_light'
require 'settings'

module Store  
  def self.setup
    if Settings.mongo['replica_set']
      mongo_connection = Mongo::ReplSetConnection.new([Settings.mongo['host1'], Settings.mongo['port1']], [Settings.mongo['host2'], Settings.mongo['port2']], 
      {
        :read => :secondary,
        :name => Settings.mongo['replica_set']
      })
    else
      mongo_connection = Mongo::Connection.new(Settings.mongo['host'], Settings.mongo['port'])
    end
    
    MongoLight.configure do |config|
      config.connection = mongo_connection
      config.database = Settings.mongo['name']
      config.skip_replica_concern = Rails.env.test?
    end

    @@redis = Redis.new(:host => Settings.redis['host'], :port => Settings.redis['port'])
    @@redis.select(Settings.redis['database'])
    @@aws_bucket = Settings.aws['bucket']
    handle_passenger_forking
  end

  def self.[](collection_name)
    MongoLight::Connection[collection_name]
  end
  
  def self.redis
    @@redis
  end
  
  def self.handle_passenger_forking
    if defined?(PhusionPassenger)
      PhusionPassenger.on_event(:starting_worker_process) do |forked|
        @@redis.client.reconnect if forked
      end
    end
  end
end
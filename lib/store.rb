require 'redis'
require 'mongo'
require 'settings'

module Store  
  def self.setup
    if Settings.mongo['replica_set']
      @@mongo_connection = Mongo::ReplSetConnection.new([Settings.mongo['host'], Settings.mongo['port']], 
      {
        :read_secondary => true,
        :rs_name => Settings.mongo['replica_set']
      })
    else
      @@mongo_connection = Mongo::Connection.new(Settings.mongo['host'], Settings.mongo['port'])
    end
    @@mongo_database = @@mongo_connection.db(Settings.mongo['name'])
    handle_passenger_forking
    
    @@redis = Redis.new(:host => Settings.redis['host'], :port => Settings.redis['port'])
    @@redis.select(Settings.redis['database'])
    @@aws_bucket = Settings.aws['bucket']
  end
  
  def self.mongo_collections
    @@mongo_database.collections
  end
  
  def self.redis
    @@redis
  end

  def self.[](collection_name)
    @@mongo_database.collection(collection_name)
  end
  
  def self.handle_passenger_forking
    if defined?(PhusionPassenger)
      PhusionPassenger.on_event(:starting_worker_process) do |forked|
        @@mongo_connection.connect if forked
      end
    end
  end
end
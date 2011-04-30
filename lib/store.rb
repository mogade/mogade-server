require 'mongo'
require 'mongo_extension'
require 'settings'

module Store  
  def self.setup
    if Settings.store['replica_set']
      @@connection = Mongo::ReplSetConnection.new([Settings.store['host'], Settings.store['port']], 
      {
        :read_secondary => true,
        :rs_name => Settings.store['replica_set']
      })
    else
      @@connection = Mongo::Connection.new(Settings.store['host'], Settings.store['port'])
    end
    @@database = @@connection.db(Settings.store['name'])
    handle_passenger_forking
  end
  
  def self.connection
    @@connection
  end
  
  def self.database
    @@database
  end
  
  def self.[](collection_name)
    database.collection(collection_name)
  end
  
  def self.handle_passenger_forking
    if defined?(PhusionPassenger)
      PhusionPassenger.on_event(:starting_worker_process) do |forked|
        @@connection.connect if forked
      end
    end
  end
end
require 'mongo'
require 'mongo_extension'
require 'store'

Store.setup

[Score.daily_collection, Score.weekly_collection, Score.overall_collection].each do |collection|
  collection.ensure_index([['lid', Mongo::ASCENDING], ['u', Mongo::ASCENDING]], {:unique => true})
end
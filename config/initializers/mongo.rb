require 'mongo'
require 'mongo_extension'
require 'store'

Store.setup

Score.daily_collection.ensure_index([['lid', Mongo::ASCENDING], ['cat', Mongo::ASCENDING], ['p', Mongo::DESCENDING]])
Score.weekly_collection.ensure_index([['lid', Mongo::ASCENDING], ['cat', Mongo::ASCENDING], ['p', Mongo::DESCENDING]])
Score.overall_collection.ensure_index([['lid', Mongo::ASCENDING], ['p', Mongo::DESCENDING]])
HighScores.collection.ensure_index([['lid', Mongo::ASCENDING], ['u', Mongo::ASCENDING]], {:unique => true})
Developer.collection.ensure_index([['e', Mongo::ASCENDING]], {:unique => true})
Developer.collection.ensure_index([['a', Mongo::ASCENDING]], {:unique => true})
EarnedAchievement.collection.ensure_index([['aid', Mongo::ASCENDING], ['u', Mongo::ASCENDING]], {:unique => true})
GameError.collection.ensure_index([['gid', Mongo::ASCENDING], ['uat', Mongo::DESCENDING]])
GameError.collection.ensure_index([['h', Mongo::ASCENDING]], {:unique => true})
require 'mongo'
require 'mongo_extension'
require 'store'

Store.setup

Score.collection.ensure_index([['lid', Mongo::ASCENDING], ['u', Mongo::ASCENDING]], {:unique => true})
Score.collection.ensure_index([['lid', Mongo::ASCENDING], ['d.p', Mongo::DESCENDING], ['d.s', Mongo::ASCENDING]], {:sparse => true})
Score.collection.ensure_index([['lid', Mongo::ASCENDING], ['w.p', Mongo::DESCENDING], ['w.s', Mongo::ASCENDING]], {:sparse => true})
Score.collection.ensure_index([['lid', Mongo::ASCENDING], ['o.p', Mongo::DESCENDING]], {:sparse => true})
ScoreDaily.collection.ensure_index([['lid', Mongo::ASCENDING], ['u', Mongo::ASCENDING]])
ScoreDaily.collection.ensure_index([['lid', Mongo::ASCENDING], ['dt', Mongo::ASCENDING], ['p', Mongo::DESCENDING]])

Developer.collection.ensure_index([['e', Mongo::ASCENDING]], {:unique => true})
Developer.collection.ensure_index([['a', Mongo::ASCENDING]])
EarnedAchievement.collection.ensure_index([['aid', Mongo::ASCENDING], ['u', Mongo::ASCENDING]], {:unique => true})
GameError.collection.ensure_index([['gid', Mongo::ASCENDING], ['uat', Mongo::DESCENDING]])
GameError.collection.ensure_index([['h', Mongo::ASCENDING]], {:unique => true})
Asset.collection.ensure_index([['gid', Mongo::ASCENDING]])
Twitter.collection.ensure_index([['gid', Mongo::ASCENDING]])
Twitter.collection.ensure_index([['lid', Mongo::ASCENDING]])
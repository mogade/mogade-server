require 'factory_girl'

Factory.define :game do |g|
  g.id Id.from_string('111111111111111111111111')
  g.secret "it's over 9000"
  g.name "power level?"
end

Factory.define :leaderboard do |l|
  l.id Id.from_string('222222222222222222222222')
  l.offset 0
  l.game_id Id.from_string('111111111111111111111111')
  l.type LeaderboardType::HighToLow
end

Factory.define :player do |p|
  p.username 'leto'
  p.userkey 'golden path'
end

Factory.sequence :unique do |n|
  "unique-#{n}"
end

Factory.define :score do |s|
  s.leaderboard_id Id.from_string('222222222222222222222222')
  s.unique {Factory.next(:unique)}
  s.username {Factory.next(:unique)}
end

Factory.define :score_data do |s|
  s.points 0
  s.stamp nil
  s.data nil
end

Factory.define :score_daily do |s|
  s.leaderboard_id Id.from_string('222222222222222222222222')
  s.unique {Factory.next(:unique)}
  s.username {Factory.next(:unique)}
  s.points 0
  s.stamp nil
end

Factory.sequence :name do |n|
  "duncan-#{n}"
end

Factory.sequence :email do |n|
  "duncan#{n}@dune.gov"
end

Factory.define :developer do |d|
  d.name {Factory.next(:name)}
  d.email {Factory.next(:email)}
  d.password {BCrypt::Password.create('shhh')}
  d.status DeveloperStatus::Enabled
  d.action 'the_action'
  d.game_ids {[]}
end

Factory.define :achievement do |a|
  a.name 'My achievement has a first name'
  a.description 'Its h-o-m-e-r'
  a.points 200
  a.game_id Id.from_string('111111111111111111111111')
end

Factory.define :game_error do |e|
  e.count 1
  e.subject 'the subject'
  e.details 'the details'
  e.game_id Id.from_string('111111111111111111111111')
end

Factory.define :profile do |p|
  p.name 'the profile'
  p.enabled true
  p.description 'mind blowing'
end
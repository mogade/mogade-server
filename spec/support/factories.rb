require 'factory_girl'

Factory.define :game do |g|
  g.id Id.from_string('111111111111111111111111')
  g.secret "it's over 9000"
end

Factory.define :leaderboard do |l|
  l.id Id.from_string('222222222222222222222222')
  l.offset 0
  l.game_id Id.from_string('111111111111111111111111')
end

Factory.define :player do |p|
  p.username 'leto'
  p.userkey 'golden path'
end

Factory.sequence :unique do |n|
  "unique-#{n}"
end

Factory.define :high_scores do |h|
  h.leaderboard_id Id.from_string('222222222222222222222222')
  h.unique {Factory.next(:unique)}
  #h.unique Factory.build(:player).unique
  h.daily_points 0
  h.daily_dated nil
  h.weekly_points 0
  h.weekly_dated nil
  h.overall_points 0
end
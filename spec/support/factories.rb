require 'factory_girl'

Factory.define :game do |g|
  g.id Id.from_string('4dbd4ed9563d8a504000000e')
  g.secret "it's over 9000"
end

Factory.define :leaderboard do |l|
  l.offset 0
  l.game_id Id.from_string('4dbd4ed9563d8a504000000e')
end


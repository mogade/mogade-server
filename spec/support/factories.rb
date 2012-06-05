require 'factory_girl'

FactoryGirl.define do
  factory :game do
    id Id.from_string('111111111111111111111111')
    secret "it's over 9000"
    name "power level?"
  end

  factory :leaderboard do
    id Id.from_string('222222222222222222222222')
    offset 0
    game_id Id.from_string('111111111111111111111111')
    type LeaderboardType::HighToLow
  end

  factory :player do
    username 'leto'
    userkey 'golden path'
  end

  factory :score do
    leaderboard_id Id.from_string('222222222222222222222222')
    sequence(:unique) {|n| "unique-#{n}" }
    sequence(:username) {|n| "username-#{n}" }
  end

  factory :score_data do
    points 0
    stamp nil
    data nil
  end

  factory :score_daily do
    leaderboard_id Id.from_string('222222222222222222222222')
    sequence(:unique) {|n| "unique-#{n}" }
    sequence(:username) {|n| "username-#{n}" }
    points 0
    stamp nil
  end

  factory :asset do
    sequence(:name) {|n| "asset-#{n}" }
    type 2
    file nil
    meta "my meta has a first name, it's h-o-m-e-r"
  end

  factory :developer do
    sequence(:name) {|n| "duncan-#{n}" }
    sequence(:email) {|n| "duncan#{n}@dune.gov" }
    password {BCrypt::Password.create('shhh')}
    status DeveloperStatus::Enabled
    action 'the_action'
    game_ids {[]}
  end

  factory :achievement do
    name 'My achievement has a first name'
    description 'Its h-o-m-e-r'
    points 200
    game_id Id.from_string('111111111111111111111111')
  end

  factory :game_error do
    count 1
    subject 'the subject'
    details 'the details'
    game_id Id.from_string('111111111111111111111111')
  end

  factory :profile do
    name 'the profile'
    enabled true
    description 'mind blowing'
  end

  factory :twitter do
    token 'tkk'
    secret 'see'
    game_id Id.from_string('111111111111111111111111')

  end
end
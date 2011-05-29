require 'spec_helper'

describe ScoreDeleter, :count do
  it "returns the count of for a username match for all scopes" do
    leaderboard = Factory.build(:leaderboard)
    [LeaderboardScope::Daily, LeaderboardScope::Weekly, LeaderboardScope::Overall].each do |scope|
      name = Score.scope_to_name(scope)
      Factory.create(:score, {:username => 'baron', :leaderboard_id => leaderboard.id, name => Factory.build(:score_data, {:points => 23})})
      Factory.create(:score, {:username => 'baron', :leaderboard_id => leaderboard.id, name => Factory.build(:score_data, {:points => 33})})
      Factory.create(:score, {:username => 'baron', :leaderboard_id => leaderboard.id, name => nil})
      ScoreDeleter.count(leaderboard, scope, ScoreDeleterField::UserName, 3, 'baron').should == 2
      ScoreDeleter.count(leaderboard, scope, ScoreDeleterField::UserName, 3, 'leto').should == 0
    end
  end

  it "returns the count of for a point less than match for all scopes" do
    leaderboard = Factory.build(:leaderboard)
    [LeaderboardScope::Daily, LeaderboardScope::Weekly, LeaderboardScope::Overall].each do |scope|
      name = Score.scope_to_name(scope)
      Factory.create(:score, {:leaderboard_id => leaderboard.id, name => Factory.build(:score_data, {:points => 4})})
      Factory.create(:score, {:leaderboard_id => leaderboard.id, name => Factory.build(:score_data, {:points => 4})})
      Factory.create(:score, {:leaderboard_id => leaderboard.id, name => Factory.build(:score_data, {:points => 5})})

      ScoreDeleter.count(leaderboard, scope, ScoreDeleterField::Points, 1, 5).should == 2
      ScoreDeleter.count(leaderboard, scope, ScoreDeleterField::Points, 1, 1).should == 0
    end
  end
  
it "returns the count of for a point less than or equal match for all scopes" do
   leaderboard = Factory.build(:leaderboard)
   [LeaderboardScope::Daily, LeaderboardScope::Weekly, LeaderboardScope::Overall].each do |scope|
     name = Score.scope_to_name(scope)
     Factory.create(:score, {:leaderboard_id => leaderboard.id, name => Factory.build(:score_data, {:points => 4})})
     Factory.create(:score, {:leaderboard_id => leaderboard.id, name => Factory.build(:score_data, {:points => 4})})
     Factory.create(:score, {:leaderboard_id => leaderboard.id, name => Factory.build(:score_data, {:points => 5})})

     ScoreDeleter.count(leaderboard, scope, ScoreDeleterField::Points, 2, 5).should == 3
     ScoreDeleter.count(leaderboard, scope, ScoreDeleterField::Points, 2, 2).should == 0
   end
 end
 
 it "returns the count of for a point equal match for all scopes" do
   leaderboard = Factory.build(:leaderboard)
   [LeaderboardScope::Daily, LeaderboardScope::Weekly, LeaderboardScope::Overall].each do |scope|
     name = Score.scope_to_name(scope)
     Factory.create(:score, {:leaderboard_id => leaderboard.id, name => Factory.build(:score_data, {:points => 4})})
     Factory.create(:score, {:leaderboard_id => leaderboard.id, name => Factory.build(:score_data, {:points => 4})})
     
     ScoreDeleter.count(leaderboard, scope, ScoreDeleterField::Points, 3, 4).should == 2
     ScoreDeleter.count(leaderboard, scope, ScoreDeleterField::Points, 3, 6).should == 0
   end
 end
 
 it "returns the count of for a point greater than or equal match for all scopes" do
   leaderboard = Factory.build(:leaderboard)
   [LeaderboardScope::Daily, LeaderboardScope::Weekly, LeaderboardScope::Overall].each do |scope|
     name = Score.scope_to_name(scope)
     Factory.create(:score, {:leaderboard_id => leaderboard.id, name => Factory.build(:score_data, {:points => 4})})
     Factory.create(:score, {:leaderboard_id => leaderboard.id, name => Factory.build(:score_data, {:points => 4})})
     Factory.create(:score, {:leaderboard_id => leaderboard.id, name => Factory.build(:score_data, {:points => 5})})

     ScoreDeleter.count(leaderboard, scope, ScoreDeleterField::Points, 4, 3).should == 3
     ScoreDeleter.count(leaderboard, scope, ScoreDeleterField::Points, 4, 7).should == 0
   end
 end
 
 it "returns the count of for a point greater than match for all scopes" do
   leaderboard = Factory.build(:leaderboard)
   [LeaderboardScope::Daily, LeaderboardScope::Weekly, LeaderboardScope::Overall].each do |scope|
     name = Score.scope_to_name(scope)
     Factory.create(:score, {:leaderboard_id => leaderboard.id, name => Factory.build(:score_data, {:points => 4})})
     Factory.create(:score, {:leaderboard_id => leaderboard.id, name => Factory.build(:score_data, {:points => 4})})
     Factory.create(:score, {:leaderboard_id => leaderboard.id, name => Factory.build(:score_data, {:points => 5})})

     ScoreDeleter.count(leaderboard, scope, ScoreDeleterField::Points, 5, 4).should == 1
     ScoreDeleter.count(leaderboard, scope, ScoreDeleterField::Points, 5, 10).should == 0
   end
 end
end
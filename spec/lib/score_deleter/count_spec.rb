require 'spec_helper'

describe ScoreDeleter, :count do
  it "returns the count of for a username match for all scopes" do
    leaderboard = Factory.build(:leaderboard)
    [LeaderboardScope::Daily, LeaderboardScope::Weekly, LeaderboardScope::Overall].each do |scope|
      Score.collection(scope).save(Score.map({:username => 'baron', :leaderboard_id => leaderboard.id}))
      Score.collection(scope).save(Score.map({:username => 'baron', :leaderboard_id => leaderboard.id}))
      ScoreDeleter.count(leaderboard, scope, ScoreDeleterField::UserName, 3, 'baron').should == 2
      ScoreDeleter.count(leaderboard, scope, ScoreDeleterField::UserName, 3, 'leto').should == 0
    end
  end

  it "returns the count of for a point less than match for all scopes" do
    leaderboard = Factory.build(:leaderboard)
    [LeaderboardScope::Daily, LeaderboardScope::Weekly, LeaderboardScope::Overall].each do |scope|
      Score.collection(scope).save(Score.map({:points => 4, :leaderboard_id => leaderboard.id}))
      Score.collection(scope).save(Score.map({:points => 4, :leaderboard_id => leaderboard.id}))
      Score.collection(scope).save(Score.map({:points => 5, :leaderboard_id => leaderboard.id}))
      ScoreDeleter.count(leaderboard, scope, ScoreDeleterField::Points, 1, 5).should == 2
      ScoreDeleter.count(leaderboard, scope, ScoreDeleterField::Points, 1, 1).should == 0
    end
  end
  
  it "returns the count of for a point less than or equal match for all scopes" do
    leaderboard = Factory.build(:leaderboard)
    [LeaderboardScope::Daily, LeaderboardScope::Weekly, LeaderboardScope::Overall].each do |scope|
      Score.collection(scope).save(Score.map({:points => 4, :leaderboard_id => leaderboard.id}))
      Score.collection(scope).save(Score.map({:points => 4, :leaderboard_id => leaderboard.id}))
      Score.collection(scope).save(Score.map({:points => 5, :leaderboard_id => leaderboard.id}))
      ScoreDeleter.count(leaderboard, scope, ScoreDeleterField::Points, 2, 5).should == 3
      ScoreDeleter.count(leaderboard, scope, ScoreDeleterField::Points, 2, 2).should == 0
    end
  end
  
  it "returns the count of for a point equal match for all scopes" do
    leaderboard = Factory.build(:leaderboard)
    [LeaderboardScope::Daily, LeaderboardScope::Weekly, LeaderboardScope::Overall].each do |scope|
      Score.collection(scope).save(Score.map({:points => 4, :leaderboard_id => leaderboard.id}))
      Score.collection(scope).save(Score.map({:points => 4, :leaderboard_id => leaderboard.id}))
      ScoreDeleter.count(leaderboard, scope, ScoreDeleterField::Points, 3, 4).should == 2
      ScoreDeleter.count(leaderboard, scope, ScoreDeleterField::Points, 3, 6).should == 0
    end
  end
  
  it "returns the count of for a point greater than or equal match for all scopes" do
    leaderboard = Factory.build(:leaderboard)
    [LeaderboardScope::Daily, LeaderboardScope::Weekly, LeaderboardScope::Overall].each do |scope|
      Score.collection(scope).save(Score.map({:points => 4, :leaderboard_id => leaderboard.id}))
      Score.collection(scope).save(Score.map({:points => 4, :leaderboard_id => leaderboard.id}))
      Score.collection(scope).save(Score.map({:points => 5, :leaderboard_id => leaderboard.id}))
      ScoreDeleter.count(leaderboard, scope, ScoreDeleterField::Points, 4, 3).should == 3
      ScoreDeleter.count(leaderboard, scope, ScoreDeleterField::Points, 4, 7).should == 0
    end
  end
  
  it "returns the count of for a point greater than match for all scopes" do
    leaderboard = Factory.build(:leaderboard)
    [LeaderboardScope::Daily, LeaderboardScope::Weekly, LeaderboardScope::Overall].each do |scope|
      Score.collection(scope).save(Score.map({:points => 4, :leaderboard_id => leaderboard.id}))
      Score.collection(scope).save(Score.map({:points => 4, :leaderboard_id => leaderboard.id}))
      Score.collection(scope).save(Score.map({:points => 5, :leaderboard_id => leaderboard.id}))
      ScoreDeleter.count(leaderboard, scope, ScoreDeleterField::Points, 5, 4).should == 1
      ScoreDeleter.count(leaderboard, scope, ScoreDeleterField::Points, 5, 10).should == 0
    end
  end

end
require 'spec_helper'

describe ScoreDeleter, :delete do
  it "deletes for a username match for all scopes" do
    leaderboard = Factory.build(:leaderboard)
    [LeaderboardScope::Daily, LeaderboardScope::Weekly, LeaderboardScope::Overall].each do |scope|
      Score.collection(scope).save(Score.map({:username => 'baron', :leaderboard_id => leaderboard.id}))
      Score.collection(scope).save(Score.map({:username => 'baron', :leaderboard_id => leaderboard.id}))
      
      ScoreDeleter.delete(leaderboard, scope, ScoreDeleterField::UserName, 3, 'leto')
      Score.collection(scope).count.should == 2
      
      ScoreDeleter.delete(leaderboard, scope, ScoreDeleterField::UserName, 3, 'baron')
      Score.collection(scope).count.should == 0
    end
  end

  it "deletes for a point less than match for all scopes" do
    leaderboard = Factory.build(:leaderboard)
    [LeaderboardScope::Daily, LeaderboardScope::Weekly, LeaderboardScope::Overall].each do |scope|
      Score.collection(scope).save(Score.map({:points => 4, :leaderboard_id => leaderboard.id}))
      Score.collection(scope).save(Score.map({:points => 4, :leaderboard_id => leaderboard.id}))
      Score.collection(scope).save(Score.map({:points => 5, :leaderboard_id => leaderboard.id}))
      
      ScoreDeleter.delete(leaderboard, scope, ScoreDeleterField::Points, 1, 1)
      Score.collection(scope).count.should == 3
      
      ScoreDeleter.delete(leaderboard, scope, ScoreDeleterField::Points, 1, 5)
      Score.collection(scope).count.should == 1
    end
  end
  
  it "returns the count of for a point less than or equal match for all scopes" do
    leaderboard = Factory.build(:leaderboard)
    [LeaderboardScope::Daily, LeaderboardScope::Weekly, LeaderboardScope::Overall].each do |scope|
      Score.collection(scope).save(Score.map({:points => 4, :leaderboard_id => leaderboard.id}))
      Score.collection(scope).save(Score.map({:points => 4, :leaderboard_id => leaderboard.id}))
      Score.collection(scope).save(Score.map({:points => 5, :leaderboard_id => leaderboard.id}))
      
      ScoreDeleter.delete(leaderboard, scope, ScoreDeleterField::Points, 2, 2)
      Score.collection(scope).count.should == 3
      
      ScoreDeleter.delete(leaderboard, scope, ScoreDeleterField::Points, 2, 5)
      Score.collection(scope).count.should == 0
    end
  end
  
  it "returns the count of for a point equal match for all scopes" do
    leaderboard = Factory.build(:leaderboard)
    [LeaderboardScope::Daily, LeaderboardScope::Weekly, LeaderboardScope::Overall].each do |scope|
      Score.collection(scope).save(Score.map({:points => 4, :leaderboard_id => leaderboard.id}))
      Score.collection(scope).save(Score.map({:points => 4, :leaderboard_id => leaderboard.id}))
  
      ScoreDeleter.delete(leaderboard, scope, ScoreDeleterField::Points, 3, 6)
      Score.collection(scope).count.should == 2
      
      ScoreDeleter.delete(leaderboard, scope, ScoreDeleterField::Points, 3, 4)
      Score.collection(scope).count.should == 0
    end
  end
  
  it "returns the count of for a point greater than or equal match for all scopes" do
    leaderboard = Factory.build(:leaderboard)
    [LeaderboardScope::Daily, LeaderboardScope::Weekly, LeaderboardScope::Overall].each do |scope|
      Score.collection(scope).save(Score.map({:points => 4, :leaderboard_id => leaderboard.id}))
      Score.collection(scope).save(Score.map({:points => 4, :leaderboard_id => leaderboard.id}))
      Score.collection(scope).save(Score.map({:points => 5, :leaderboard_id => leaderboard.id}))
      
      ScoreDeleter.delete(leaderboard, scope, ScoreDeleterField::Points, 4, 7)
      Score.collection(scope).count.should == 3
      
      ScoreDeleter.delete(leaderboard, scope, ScoreDeleterField::Points, 4, 4)
      Score.collection(scope).count.should == 0
    end
  end
  
  it "returns the count of for a point greater than match for all scopes" do
    leaderboard = Factory.build(:leaderboard)
    [LeaderboardScope::Daily, LeaderboardScope::Weekly, LeaderboardScope::Overall].each do |scope|
      Score.collection(scope).save(Score.map({:points => 4, :leaderboard_id => leaderboard.id}))
      Score.collection(scope).save(Score.map({:points => 4, :leaderboard_id => leaderboard.id}))
      Score.collection(scope).save(Score.map({:points => 5, :leaderboard_id => leaderboard.id}))
      
      ScoreDeleter.delete(leaderboard, scope, ScoreDeleterField::Points, 5, 10)
      Score.collection(scope).count.should == 3
      
      ScoreDeleter.delete(leaderboard, scope, ScoreDeleterField::Points, 5, 4)
      Score.collection(scope).count.should == 2
    end
  end

end
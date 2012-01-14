require 'spec_helper'

describe Player, :rename do  
  it "returns false if the new name is not valid" do
    Player.new.rename(nil, nil).should be_false
    Player.new.rename(nil, '').should be_false
    Player.new.rename(nil, 'a' * 31).should be_false
  end

  it "renames all of the user's earned achievements" do
    game = FactoryGirl.build(:game)
    achievement1 = FactoryGirl.create(:achievement, {:game_id => game.id})
    achievement2 = FactoryGirl.create(:achievement, {:game_id => game.id})
    achievement3 = FactoryGirl.create(:achievement, {:game_id => game.id})
    achievement4 = FactoryGirl.create(:achievement, {:game_id => Id.new})
    player1 = FactoryGirl.build(:player, {:username => 'leeto'})
    player2 = FactoryGirl.build(:player, {:username => 'ghanima'})
    
    EarnedAchievement.create(achievement1, player1)
    EarnedAchievement.create(achievement2, player1)
    EarnedAchievement.create(achievement4, player1)
    EarnedAchievement.create(achievement1, player2)
    EarnedAchievement.create(achievement2, player2)
    EarnedAchievement.create(achievement3, player2)
    EarnedAchievement.create(achievement4, player2)

    player1.rename(game, 'leto')
    EarnedAchievement.count().should == 7
    EarnedAchievement.count({:username => 'ghanima'}).should == 4
    EarnedAchievement.count({:username => 'leeto', :achievement_id => achievement4.id}).should == 1
    EarnedAchievement.count({:username => 'leto', :achievement_id => achievement1.id}).should == 1
    EarnedAchievement.count({:username => 'leto', :achievement_id => achievement2.id}).should == 1
  end

  it "renames all the user's scores" do
    game = FactoryGirl.build(:game)
    leaderboard1 = FactoryGirl.create(:leaderboard, {:id => Id.new, :game_id => game.id})
    leaderboard2 = FactoryGirl.create(:leaderboard, {:id => Id.new, :game_id => game.id})
    leaderboard3 = FactoryGirl.create(:leaderboard, {:id => Id.new, :game_id => game.id})
    leaderboard4 = FactoryGirl.create(:leaderboard, {:id => Id.new, :game_id => Id.new})
    player1 = FactoryGirl.build(:player, {:username => 'gokuu'})
    player2 = FactoryGirl.build(:player, {:username => 'gohan'})

    Score.save(leaderboard1, player1, 10)
    Score.save(leaderboard2, player1, 25)
    Score.save(leaderboard4, player1, 5)
    Score.save(leaderboard1, player2, 1)
    Score.save(leaderboard2, player2, 2)
    Score.save(leaderboard3, player2, 3)
    Score.save(leaderboard4, player2, 4)
    
    [leaderboard1, leaderboard2, leaderboard3].each do |lb|
      LeaderboardScope.all_scopes.each do |scope|
        Rank.should_receive(:rename).with(lb, scope, player1.unique, Digest::SHA1.hexdigest('goku' +  player1.userkey))
      end
    end
    player1.rename(game, 'goku')

    Score.count.should == 7
    Score.count({:username => player2.username}).should == 4
    Score.count({:username => 'gokuu', :leaderboard_id => leaderboard4.id}).should == 1
    Score.count({:username => 'goku', :leaderboard_id => leaderboard1.id}).should == 1
    Score.count({:username => 'goku', :leaderboard_id => leaderboard2.id}).should == 1
  end
end
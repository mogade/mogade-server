require 'spec_helper'

describe Score, :save do
  it "saves the data with the scores" do
    @player = Factory.build(:player)
    @leaderboard = Factory.build(:leaderboard)
    @player.stub!(:high_scores).and_return(Factory.build(:high_scores))
    Score.save(@leaderboard, @player, 100, "i-will-not-fear-over-9000")
    all_scores_have_data('i-will-not-fear-over-9000')
  end

  it "limits the data to 50 characters" do
    @player = Factory.build(:player)
    @leaderboard = Factory.build(:leaderboard)
    @player.stub!(:high_scores).and_return(Factory.build(:high_scores))
    Score.save(@leaderboard, @player, 100, '1'* 55)
    all_scores_have_data('1' * 50)
  end
  
  it "saves no data when none is provide" do
    @player = Factory.build(:player)
    @leaderboard = Factory.build(:leaderboard)
    @player.stub!(:high_scores).and_return(Factory.build(:high_scores))
    Score.save(@leaderboard, @player, 100)
    all_scores_have_data(nil)
  end
  
  it "informs the high score about the new score" do
    player = Factory.build(:player)
    leaderboard = Factory.build(:leaderboard)
    scores = Factory.build(:high_scores)
    player.stub!(:high_scores).and_return(scores)
    changed = {:daily => true}
    scores.should_receive(:has_new_score).with(100).and_return(changed)
    Score.save(leaderboard, player, 100).should == changed
  end
  
  def all_scores_have_data(data)
    selector = {:lid => @leaderboard.id}
    selector[:d] = data.nil? ? {'$exists' => false} : data
    Score.weekly_collection.find(selector).count.should == 1
  end
end
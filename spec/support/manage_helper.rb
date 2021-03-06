module ManageHelper

  def self.game_id
    @@game_id ||= Id.new
  end
  
  def setup      
    before :each do
      Rails.cache.clear
      @developer = FactoryGirl.create(:developer)
      session[:dev_id] = @developer.id
      
      @game = FactoryGirl.create(:game, {:id => ManageHelper.game_id})
      @developer.game_ids = [@game.id]
      
      Developer.stub!(:find_by_id).with(@developer.id).and_return(@developer)
      Game.stub(:find_by_id).with(@game.id).and_return(@game)
    end
  end
  
  def it_ensures_a_logged_in_user(verb, action)
    it "redirects to login page if session isn't set" do
      session.delete(:dev_id)
      self.send verb, action
      response.should redirect_to('/manage/sessions/new')
    end
    it "redirects to login page if session isn't valid" do
      Developer.stub!(:find_by_id).with('invalid').and_return(nil)
      session[:dev_id] = 'invalid'
      self.send verb, action
      response.should redirect_to('/manage/sessions/new')
    end
    it "redirects to login page if session doesn't belong to developer" do
      session[:dev_id] = Id.new
      Developer.stub!(:find_by_id).with(session[:dev_id]).and_return(nil)
      self.send verb, action
      response.should redirect_to('/manage/sessions/new')
    end
    it "loads the developer " do
      self.send verb, action
      assigns[:current_developer].should == @developer
    end
  end
  
  def it_ensures_developer_owns_the_game(verb, action, block = nil)
    it "redirects to home if id isn't present" do
      self.send verb, action
      response.should redirect_to('/manage/games')
      flash[:error].should == 'you do not have access to perform that action'
    end
    it "redirect to home if developer doesn't own the game" do
      Game.stub!(:find_by_id).with(anything()).and_return(FactoryGirl.build(:game))
      game = FactoryGirl.create(:game, {:id => Id.new})
      self.send verb, action, {:id => game.id}
      response.should redirect_to('/manage/games')
      flash[:error].should == 'you do not have access to perform that action'
    end
    it "loads the game by id" do
      params = block.nil? ? {} : block.call
      self.send verb, action, params.merge({:id => @game.id})
      assigns[:game].should == @game
    end
    it "loads the game by game_id" do
      params = block.nil? ? {} : block.call
      self.send verb, action, params.merge({:game_id => @game.id})
      assigns[:game].should == @game
    end
  end
end
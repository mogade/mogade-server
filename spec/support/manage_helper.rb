module ManageHelper

  def setup      
    before :each do
      Rails.cache.clear      
      @developer = Factory.create(:developer)
      session[:dev_id] = @developer.id
      Developer.stub!(:find_by_id).with(@developer.id).and_return(@developer)
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
end
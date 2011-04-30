require 'spec_helper'

describe 'MongoExtension', :duplicate? do
  before :each do
    @collection = Store['unique_test']
    @collection.create_index(:email, {:unique => true})
  end
  
  after :each do
    @collection.drop
  end
    
  it "returns true if the error is a duplicate key error" do
    @collection.insert({:email => 'leto@dune.gov'}, {:safe => true})
    begin
      @collection.insert({:email => 'leto@dune.gov'}, {:safe => true})
      true.should be_false #puke
    rescue Mongo::OperationFailure => e
      e.duplicate?.should be_true
    end
  end
end
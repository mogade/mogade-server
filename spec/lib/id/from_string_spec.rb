require 'spec_helper'

describe Id, :from_string do

  it "returns nil for an invalid id" do
    Id.from_string(nil).should be_nil
    Id.from_string('').should be_nil
    Id.from_string(123).should be_nil
    Id.from_string('abc').should be_nil
  end
  
  it "returns the id as-is if it's already an id object" do
    id = BSON::ObjectId.new
    Id.from_string(id).should == id
  end
  
  it "returns the id from a string" do
    id = BSON::ObjectId.new
    Id.from_string(id.to_s).should == id
  end
end
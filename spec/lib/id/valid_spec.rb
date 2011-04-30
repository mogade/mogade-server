require 'spec_helper'

describe Id, :valid? do

  it "returns false for a nil" do
    Id.valid?(nil).should be_false
  end
  it "returns false for a blank" do
    Id.valid?('').should be_false
  end
  it "returns false for an invalid id" do
    Id.valid?(2323).should be_false
    Id.valid?("abc").should be_false
  end
  it "returns true for a valid id as an object" do
    Id.valid?(BSON::ObjectId.new).should be_true
  end
  it "returns true for a valid id as a string" do
    Id.valid?(BSON::ObjectId.new.to_s).should be_true
  end

end
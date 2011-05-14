require 'spec_helper'

describe Id, :expired? do

  it "returns true when the id is expired" do
    id = Id.new
    id.stub!(:generation_time).and_return(Time.now - 87000*4)
    Id.expired?(id, 3).should be_true
  end
  
  it "returns false when the id is not expired" do
    id = Id.new
    id.stub!(:generation_time).and_return(Time.now - 86400*3 - 1000)
    Id.expired?(id, 3).should be_false
  end
  
end
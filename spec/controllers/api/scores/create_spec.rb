require 'spec_helper'

describe Api::ScoresController, :create do
  extend ApiHelper
  
  setup
  it_ensures_a_valid_context :post, :create
  it_ensures_a_signed_request :post, :create

end